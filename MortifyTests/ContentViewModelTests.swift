import XCTest
@testable import Mortify

final class ContentViewModelTests: XCTestCase {
    func testInvalidAreaMarked() {
        let store = HistoryStore()
        let vm = ContentViewModel(historyStore: store)
        vm.area = "abc"
        vm.onInputChanged()

        XCTAssertTrue(vm.invalidFields.contains(.area))
    }

    func testFloorAboveTotalInvalid() {
        let store = HistoryStore()
        let vm = ContentViewModel(historyStore: store)
        vm.floor = 10
        vm.floorsTotal = 5
        vm.onInputChanged()

        XCTAssertTrue(vm.invalidFields.contains(.floor))
        XCTAssertTrue(vm.invalidFields.contains(.floorsTotal))
    }
}
