# `swift-format` Configuration

`swift-format` allows users to configure a subset of its behavior, both when
used as a command line tool or as an API.

## Command Line Configuration

A `swift-format` configuration file is a JSON file with the following
top-level keys and values:

*   `version` _(number)_: The version of the configuration file. For now, this
    should always be `1`.

*   `lineLength` _(number)_: The maximum allowed length of a line, in
    characters.

*   `indentation` _(object)_: The kind and amount of whitespace that should be
    added when indenting one level. The object value of this property should
    have **exactly one of the following properties:**

    *   `spaces` _(number)_: One level of indentation is the given number of
        spaces.
    *   `tabs` _(number)_: One level of indentation is the given number of
        tabs.

*   `tabWidth` _(number)_: The number of spaces that should be considered
    equivalent to one tab character. This is used during line length
    calculations when tabs are used for indentation.

*   `maximumBlankLines` _(number)_: The maximum number of consecutive blank
    lines that are allowed to be present in a source file. Any number larger
    than this will be collapsed down to the maximum.

*   `respectsExistingLineBreaks` _(boolean)_: Indicates whether or not existing
    line breaks in the source code should be honored (if they are valid
    according to the style guidelines being enforced). If this settings is
    `false`, then the formatter will be more "opinionated" by only inserting
    line breaks where absolutely necessary and removing any others, effectively
    canonicalizing the output.

*   `blankLineBetweenMembers` _(object)_: Controls logic specific to the
    enforcement of blank lines between type members. The object value of this
    property has the following properties:

    *   `ignoreSingleLineProperties` _(boolean)_: If `true`, then single-line
        property declarations are allowed to appear consecutively without a
        blank line separating them.

*   `lineBreakBeforeControlFlowKeywords` _(boolean)_: Determines the
    line-breaking behavior for control flow keywords that follow a closing
    brace, like `else` and `catch`. If true, a line break will be added before
    the keyword, forcing it onto its own line. If false (the default), the
    keyword will be placed after the closing brace (separated by a space).

*   `lineBreakBeforeEachArgument` _(boolean)_: Determines the line-breaking
    behavior for generic arguments and function arguments when a declaration is
    wrapped onto multiple lines. If true, a line break will be added before each
    argument, forcing the entire argument list to be laid out vertically.
    If false (the default), arguments will be laid out horizontally first, with
    line breaks only being fired when the line length would be exceeded.

*   `indentConditionalCompilationBlocks` _(boolean)_: Determines if
    conditional compilation blocks are indented. If this setting is `false` the body
    of `#if`, `#elseif`, and `#else` is not indented. Defaults to `true`.

> TODO: Add support for enabling/disabling specific syntax transformations in
> the pipeline.

### Example

An example `.swift-format` configuration file is shown below.

```javascript
{
    "version": 1,
    "lineLength": 100,
    "indentation": {
        "spaces": 2
    },
    "maximumBlankLines": 1,
    "respectsExistingLineBreaks": true,
    "blankLineBetweenMembers": {
        "ignoreSingleLineProperties": true
    },
    "lineBreakBeforeControlFlowKeywords": true,
    "lineBreakBeforeEachArgument": true
}
```

## API Configuration

The `SwiftConfiguration` module contains a `Configuration` type that is
equivalent to the JSON structure described above. (In fact, `Configuration`
conforms to `Codable` and is how the JSON form is read from and written to
disk.)

The `SwiftFormatter` and `SwiftLinter` APIs in the `SwiftFormat` module take a
mandatory `Configuration` argument that specifies how the formatter should
behave when acting upon source code or syntax trees.

The default initializer for `Configuration` creates a value equivalent to the
default configuration that would be printed by invoking
`swift-format --mode dump-configuration`. API users can also provide their own
configuration by modifying this value or loading it from another source using
Swift's `Codable` APIs.
