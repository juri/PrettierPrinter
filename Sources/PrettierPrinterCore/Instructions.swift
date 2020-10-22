import PrettierPrinterParser

enum Instruction: Equatable {
    case newline
    case indent
    case dedent
    case insert(String)
}

private func instr(_ instructions: Instruction...) -> () -> [Instruction] {
    { instructions }
}

private func groupOpenParser(_ s: String) -> Parser<[Instruction]> {
    PrettierPrinterParser.literal(s).map(instr(.insert(s), .indent, .newline))
}

private func groupCloseParser(_ s: String) -> Parser<[Instruction]> {
    PrettierPrinterParser.literal(s).map(instr(.dedent, .newline, .insert(s)))
}

let openParenParser = groupOpenParser("(")
let closeParenParser = groupCloseParser(")")
let openBraceParser = groupOpenParser("{")
let closeBraceParser = groupCloseParser("}")
let openBracketParser = groupOpenParser("[")
let closeBracketParser = groupCloseParser("]")

let commaParser = PrettierPrinterParser.literal(",").map(instr(.insert(","), .newline))

// Handle double-quoted strings with escaped quotes inside them. Also recognize other escaped
// characters.
let escapables = #"\"0nrtvfb"#.map { c -> Parser<String> in
    let s = String(c)
    return literal(s).map(const(s))
}
let escaped = zip(literal("\\"), oneOf(escapables)).map { #"\\#($0.1)"# }
let notQuote = prefix(while: { $0 != "\"" && $0 != "\\" }).filter { !$0.isEmpty }.map(String.init)
let stringPart = oneOf([escaped, notQuote])
let stringContent = oneOrMore(stringPart, separatedBy: always(())).map { $0.joined() }

let quoted = zip(literal("\""), stringContent, literal("\"")).map { "\"\($0.1)\"" }

let quotedParser = quoted.map { [.insert(String($0))] as [Instruction] }

private let specials = ["(", ")", "[", "]", "{", "}", ",", "\""] as Set<Character>

/// A parser that converts one or more non-special characters into an `Instruction.insert`.
let otherParser = PrettierPrinterParser
    .prefix(while: { !specials.contains($0) })
    .filter { !$0.isEmpty }
    .map { [.insert(String($0.filter { $0 != "\n" }))] as [Instruction] }

let partParser = PrettierPrinterParser.oneOf([
    quotedParser,
    otherParser,
    openParenParser,
    closeParenParser,
    openBraceParser,
    closeBraceParser,
    openBracketParser,
    closeBracketParser,
    commaParser,
])

let partsParser = zeroOrMore(partParser, separatedBy: PrettierPrinterParser.always(()))
    .map { nested in
        nested.flatMap { $0 }
    }

/// Takes a list of `Instruction`s a and removes leading whitespace from any
/// `insert` that follows a `newline`.
func stripLeadingWhitespaceAfterNewline(_ instructions: [Instruction]) -> [Instruction] {
    let preceding = [Optional.none] + instructions.map(Optional.some)
    var out = [Instruction]()
    out.reserveCapacity(instructions.count)
    return zip(preceding, instructions).reduce(into: [Instruction]()) { result, pair in
        if case let .insert(str) = pair.1, pair.0 == .some(.newline) {
            result.append(.insert(String(str.drop(while: \.isWhitespace))))
        } else {
            result.append(pair.1)
        }
    }
}

/// Parses a string into a list of `Instruction`s.
let instructionsParser = partsParser
    .map(stripLeadingWhitespaceAfterNewline(_:))
