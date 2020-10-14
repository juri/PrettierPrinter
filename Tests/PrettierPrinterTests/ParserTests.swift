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

    static var allTests = [
        ("testEmpty", testEmpty),
        ("testNoSpecial", testNoSpecial),
        ("testOpenParen", testOpenParen),
        ("testStripLeadingWhitespaceAfterNewline", testStripLeadingWhitespaceAfterNewline),
        ("testPhrase", testPhrase),
    ]
}
