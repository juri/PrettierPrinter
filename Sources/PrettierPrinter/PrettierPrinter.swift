import ArgumentParser
import PrettierPrinterCore

@main
struct PrettierPrinter: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "prpr",
        abstract: "Pretty print text."
    )

    @Option(name: [.customShort("i"), .long], help: #"Indentation ("tab" or "sN" for N spaces)"#)
    var indent: Indent = .spaces(4)

    mutating func run() throws {
        print(try format(string: readInput(), settings: FormatterSettings(indent: self.indent.indentation)))
    }
}

enum Indent {
    case spaces(Int)
    case tab

    var indentation: String {
        switch self {
        case let .spaces(count): return Array(repeating: " ", count: count).joined()
        case .tab: return "\t"
        }
    }
}

extension Indent: ExpressibleByArgument {
    init?(argument: String) {
        if argument == "tab" {
            self = .tab
        } else if let first = argument.first, first == "s", let count = Int(argument.dropFirst()) {
            self = .spaces(count)
        } else {
            return nil
        }
    }
}

extension Indent: CustomStringConvertible {
    var description: String {
        switch self {
        case let .spaces(n): return "s\(n)"
        case .tab: return "tab"
        }
    }
}

private func readInput() -> String {
    sequence(
        first: readLine(strippingNewline: false) ?? "",
        next: { _ in readLine(strippingNewline: false) }
    )
    .joined()
}
