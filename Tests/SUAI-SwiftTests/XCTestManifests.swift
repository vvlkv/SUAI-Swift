import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SUAI_SwiftTests.allTests),
    ]
}
#endif
