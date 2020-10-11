//
//  Formatter.swift
//
//
//  Created by Juri Pakaste on 11.10.2020.
//

import Foundation

public struct FormatterSettings {
    public let indent: String

    public init(indent: String) {
        self.indent = indent
    }
}

public struct FormatError: Error {
    public let unparsed: String
}

public func format(string: String, settings: FormatterSettings) throws -> String {
    let match = instructionsParser.run(string)
    guard let instructions = match.match, match.rest.isEmpty else {
        throw FormatError(unparsed: String(match.rest))
    }

    let state = instructions.reduce(into: FormatState()) { state, instruction in
        switch instruction {
        case .dedent:
            state.level -= 1
        case .indent:
            state.level += 1
        case .newline:
            state.strings.append("\n")
            state.strings.append(contentsOf: Array(repeating: settings.indent, count: state.level))
        case let .insert(s):
            state.strings.append(s)
        }
    }

    return state.strings.joined()
}

private struct FormatState {
    var strings = [String]()
    var level = 0 {
        didSet {
            precondition(self.level >= 0)
        }
    }
}
