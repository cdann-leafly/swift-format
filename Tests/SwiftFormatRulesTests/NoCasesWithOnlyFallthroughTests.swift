import Foundation
import SwiftSyntax
import XCTest

@testable import SwiftFormatRules

public class NoCasesWithOnlyFallthroughTests: DiagnosingTestCase {
  func testFallthroughCases() {
    XCTAssertFormatting(NoCasesWithOnlyFallthrough.self,
                        input: """
                               switch numbers {
                               case 1: print("one")
                               case 2: fallthrough
                               case 3: fallthrough
                               case 4: print("two to four")
                               case 5: fallthrough
                               case 7: print("five or seven")
                               default: break
                               }
                               switch letters {
                               case "a": fallthrough
                               case "b", "c": fallthrough
                               case "d": print("abcd")
                               case "e": print("e")
                               case "f": fallthrough
                               case "z": print("fz")
                               default: break
                               }
                               switch tokens {
                               case .comma: print(",")
                               case .rightBrace: fallthrough
                               case .leftBrace: fallthrough
                               case .braces: print("{}")
                               case .period: print(".")
                               case .empty: fallthrough
                               default: break
                               }
                               """,
                        expected: """
                                  switch numbers {
                                  case 1: print("one")
                                  case 2...4: print("two to four")
                                  case 5, 7: print("five or seven")
                                  default: break
                                  }
                                  switch letters {
                                  case "a", "b", "c", "d": print("abcd")
                                  case "e": print("e")
                                  case "f", "z": print("fz")
                                  default: break
                                  }
                                  switch tokens {
                                  case .comma: print(",")
                                  case .rightBrace, .leftBrace, .braces: print("{}")
                                  case .period: print(".")
                                  default: break
                                  }
                                  """)
  }

  func testFallthroughCasesWithCommentsAreNotCombined() {
    XCTAssertFormatting(NoCasesWithOnlyFallthrough.self,
                         input: """
                                switch numbers {
                                case 1:
                                  return 0 // This return has an inline comment.
                                case 2: fallthrough
                                // This case is commented so it should stay.
                                case 3:
                                  fallthrough
                                case 4:
                                  // This fallthrough is commented so it should stay.
                                  fallthrough
                                case 5: fallthrough  // This fallthrough is relevant.
                                case 6:
                                  fallthrough
                                // This case has a descriptive comment.
                                case 7: print("got here")
                                }
                                """,
                         expected: """
                                   switch numbers {
                                   case 1:
                                     return 0 // This return has an inline comment.
                                   // This case is commented so it should stay.
                                   case 2...3:
                                     fallthrough
                                   case 4:
                                     // This fallthrough is commented so it should stay.
                                     fallthrough
                                   case 5: fallthrough  // This fallthrough is relevant.
                                   // This case has a descriptive comment.
                                   case 6...7: print("got here")
                                   }
                                   """)
  }

  func testCommentsAroundCombinedCasesStayInPlace() {
    XCTAssertFormatting(NoCasesWithOnlyFallthrough.self,
                         input: """
                                switch numbers {
                                case 5:
                                  return 42 // This return is important.
                                case 6: fallthrough
                                // This case has an important comment.
                                case 7: print("6 to 7")
                                case 8: fallthrough

                                // This case has an extra leading newline for emphasis.
                                case 9: print("8 to 9")
                                }
                                """,
                         expected: """
                                   switch numbers {
                                   case 5:
                                     return 42 // This return is important.
                                   // This case has an important comment.
                                   case 6...7: print("6 to 7")

                                   // This case has an extra leading newline for emphasis.
                                   case 8...9: print("8 to 9")
                                   }
                                   """)
  }
}
