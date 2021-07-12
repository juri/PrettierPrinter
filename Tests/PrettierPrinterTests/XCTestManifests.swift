import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(ParserTests.allTests),
        testCase(FormatterTests.allTests),
    ]
}
#endif
