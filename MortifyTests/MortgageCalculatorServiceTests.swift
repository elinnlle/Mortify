import XCTest
@testable import Mortify

final class MortgageCalculatorServiceTests: XCTestCase {
    func testMonthlyPaymentZeroRate() {
        let payment = MortgageCalculatorService.monthlyPayment(
            price: 1_200_000,
            downPayment: 20,
            years: 10,
            rate: 0
        )

        let loan = 1_200_000 * 0.8
        let expected = loan / (10 * 12)
        XCTAssertEqual(payment, expected, accuracy: 0.001)
    }

    func testMonthlyPaymentPositiveRate() {
        let payment = MortgageCalculatorService.monthlyPayment(
            price: 2_000_000,
            downPayment: 10,
            years: 20,
            rate: 7.5
        )

        XCTAssertTrue(payment > 0)
        XCTAssertTrue(payment.isFinite)
    }

    func testTotalOverpayment() {
        let price = 3_000_000.0
        let downPayment = 20.0
        let years = 15.0
        let payment = MortgageCalculatorService.monthlyPayment(
            price: price,
            downPayment: downPayment,
            years: years,
            rate: 9
        )

        let overpay = MortgageCalculatorService.totalOverpayment(
            price: price,
            downPayment: downPayment,
            years: years,
            monthlyPayment: payment
        )

        XCTAssertTrue(overpay >= 0)
        XCTAssertTrue(overpay.isFinite)
    }
}
