@testable import PrettierPrinterCore
import XCTest

final class PrettierPrinterTests: XCTestCase {
    func testEmpty() throws {
        let (instructions, rest) = PrettierPrinterCore.partsParser.run("")
        XCTAssertEqual(rest, "")
        XCTAssertEqual([], instructions)
    }

    func testNoSpecial() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run("abc")
        XCTAssertEqual(rest, "")
        XCTAssertEqual([.insert("abc")], instructions)
    }

    func testQuotes() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run(#"abc "z\na\"p" pop"#)
        XCTAssertEqual(rest, "")
        XCTAssertEqual([.insert("abc "), .insert(#""z\na\"p""#), .insert(" pop")], instructions)
    }

    func testEscapedSingleQuote() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run(#"abc "don\'t do it" pop"#)
        XCTAssertEqual(rest, "")
        XCTAssertEqual([.insert("abc "), .insert(#""don\'t do it""#), .insert(" pop")], instructions)
    }

    func testParensInQuotes() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run(#"abc "Olp(neep)" pop"#)
        XCTAssertEqual(rest, "")
        XCTAssertEqual([.insert("abc "), .insert(#""Olp(neep)""#), .insert(" pop")], instructions)
    }

    func testEscapedStrings() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run(#"abc\npop"#)
        XCTAssertEqual(rest, "")
        XCTAssertEqual([.insert("abc\\npop")], instructions)
    }

    func testOpenParen() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run("(")
        XCTAssertEqual(rest, "")
        XCTAssertEqual([.insert("("), .indent, .newline], instructions)
    }

    func testStripLeadingWhitespaceAfterNewline() throws {
        let input = [.insert("   hello"), .newline, .insert("   world"), .insert("   foo")] as [Instruction]
        let output = PrettierPrinterCore.stripLeadingWhitespaceAfterNewline(input)
        XCTAssertEqual(output, [.insert("   hello"), .newline, .insert("world"), .insert("   foo")])
    }

    func testPhrase() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run("Ob(foo=bar, zap=quux)")
        XCTAssertEqual(rest, "")
        XCTAssertEqual(
            [
                .insert("Ob"),
                .insert("("),
                .indent,
                .newline,
                .insert("foo=bar"),
                .insert(","),
                .newline,
                .insert("zap=quux"),
                .dedent,
                .newline,
                .insert(")"),
            ],
            instructions
        )
    }

    func testRemoveNewlines() throws {
        let (instructions, rest) = PrettierPrinterCore.instructionsParser.run("A(b\n)")
        XCTAssertEqual(rest, "")
        XCTAssertEqual(
            [
                .insert("A"),
                .insert("("),
                .indent,
                .newline,
                .insert("b"),
                .dedent,
                .newline,
                .insert(")"),
            ],
            instructions
        )
    }
}
