import XCTest
@testable import Mortify

final class CompareViewModelTests: XCTestCase {
    func testInvalidFieldsWhenFloorAboveTotal() {
        let vm = CompareViewModel()
        vm.variantA.floor = 10
        vm.variantA.floorsTotal = 5
        vm.recalculate()

        let exp = expectation(description: "recalc")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertTrue(vm.invalidFieldsA.contains(.floor))
            XCTAssertTrue(vm.invalidFieldsA.contains(.floorsTotal))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testDisabledRegionZeroesResults() {
        let vm = CompareViewModel()
        vm.selectedRegion = Region(id: "spb", title: "Санкт-Петербург", isEnabled: false)
        vm.recalculate()

        let exp = expectation(description: "recalc")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(vm.priceA, 0)
            XCTAssertEqual(vm.priceB, 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
