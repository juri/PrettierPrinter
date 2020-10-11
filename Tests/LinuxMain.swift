import XCTest

import PrettierPrinterTests

var tests = [XCTestCaseEntry]()
tests += ParserTests.allTests()
tests += FormatterTests.allTests()
XCTMain(tests)
