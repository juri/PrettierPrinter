import XCTest

import PrettierPrinterTests

var tests = [XCTestCaseEntry]()
tests += ParserTests.allTests()
XCTMain(tests)
