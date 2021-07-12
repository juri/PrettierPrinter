# PrettierPrinter

PrettierPrinter is a pretty printer for text with parentheses, brackets, braces and commas. It's suitable
for object literals output by many development environments, such as Swift or Kotlin.

## Example

```sh
$ echo '[Object(field1: value1, field2: Object(field3: 1)), Object(field1: value1, field2: "string, \"value\"")]' | prpr
[
    Object(
        field1: value1,
        field2: Object(
            field3: 1
        )
    ),
    Object(
        field1: value1,
        field2: "string, \"value\""
    )
]
```

## Installation

```sh
$ swift build -c release
$ cp .build/release/prpr /usr/local/bin
```

## License

Copyright 2021 Juri Pakaste.

PrettierPrinter is licensed under the terms of the MIT license. See the file LICENSE for details.

## Code of Conduct

Please note that this project is released with a Contributor Covenant Code of Conduct. By participating in this project you agree to abide by its terms.
