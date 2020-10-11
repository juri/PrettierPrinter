//
//  Parser.swift
//
//
//  Created by Juri Pakaste on 6.10.2020.
//

import Foundation

public struct Parser<A> {
    public let run: (inout Substring) -> A?

    public init(run: @escaping (inout Substring) -> A?) {
        self.run = run
    }
}

extension Parser {
    public func run(_ str: String) -> (match: A?, rest: Substring) {
        var str = str[...]
        let match = self.run(&str)
        return (match, str)
    }

    public func map<B>(_ f: @escaping (A) -> B) -> Parser<B> {
        Parser<B> { str -> B? in
            self.run(&str).map(f)
        }
    }

    public func filter(_ f: @escaping (A) -> Bool) -> Parser<A> {
        Parser<A> { str -> A? in
            self.run(&str).flatMap { f($0) ? $0 : nil }
        }
    }

    public func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
        Parser<B> { str -> B? in
            let original = str
            let matchA = self.run(&str)
            let parserB = matchA.map(f)
            guard let matchB = parserB?.run(&str) else {
                str = original
                return nil
            }
            return matchB
        }
    }
}

public func literal(_ p: String) -> Parser<Void> {
    Parser<Void> { str in
        guard str.hasPrefix(p) else { return nil }
        str.removeFirst(p.count)
        return ()
    }
}

public func prefix(while p: @escaping (Character) -> Bool) -> Parser<Substring> {
    Parser<Substring> { str in
        let prefix = str.prefix(while: p)
        str.removeFirst(prefix.count)
        return prefix
    }
}

public func prefix(length: Int) -> Parser<Substring> {
    Parser<Substring> { str in
        let prefix = str.prefix(length)
        guard prefix.count == length else { return nil }
        str.removeFirst(length)
        return prefix
    }
}

public func always<A>(_ a: A) -> Parser<A> {
    Parser<A> { _ in a }
}

public func oneOf<A>(_ parsers: [Parser<A>]) -> Parser<A> {
    Parser<A> { str in
        for parser in parsers {
            if let match = parser.run(&str) {
                return match
            }
        }
        return nil
    }
}

public func zeroOrMore<A>(_ p: Parser<A>, separatedBy s: Parser<Void>) -> Parser<[A]> {
    Parser<[A]> { str in
        var original = str
        var matches: [A] = []
        while let match = p.run(&str) {
            original = str
            matches.append(match)
            guard s.run(&str) != nil else {
                return matches
            }
        }
        str = original
        return matches
    }
}
