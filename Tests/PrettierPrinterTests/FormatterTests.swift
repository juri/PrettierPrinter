@testable import PrettierPrinterCore
import XCTest

class FormatterTests: XCTestCase {
    func testFormatEmpty() throws {
        let output = try format(string: "", settings: .init(indent: "\t"))
        XCTAssertEqual(output, "")
    }

    func testFormatNothingSpecial() throws {
        let output = try format(string: "asdf", settings: .init(indent: "\t"))
        XCTAssertEqual(output, "asdf")
    }

    func testFormatComplicated() throws {
        let output = try format(string: "Object(blorp=zonk, garp=bump)", settings: .init(indent: "\t"))
        XCTAssertEqual(
            output,
            "Object(\n\tblorp=zonk,\n\tgarp=bump\n)\n"
        )
    }
}
