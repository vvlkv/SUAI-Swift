import XCTest
@testable import SUAI_Swift

final class SUAI_SwiftTests: XCTestCase {
    
    func testExample() {
        
        let exp = expectation(description: "load")
        SUAI.schedule.loadEntities {
            res in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 100)
    }
    
    func testLoadSchedule() {
        let exp = expectation(description: "load")
        let e = Entity(name: "1742", type: .group, codes: Code(session: "347", semester: "50"))
        SUAI.schedule.loadSchedule(for: e) {
            res in
            
            if case .success(let sched) = res {
                print(sched)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 100)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
