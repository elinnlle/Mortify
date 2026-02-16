import Foundation

struct CalculationRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let regionId: String
    let regionTitle: String
    let area: Double
    let livingArea: Double
    let kitchenArea: Double
    let minutesToMetro: Double
    let centerDistanceKm: Double
    let rooms: Int
    let floor: Int
    let floorsTotal: Int
    let renovationRaw: String
    let apartmentTypeRaw: String
    let loanTermYears: Double
    let downPaymentPercent: Double
    let interestRatePercent: Double
    let predictedPrice: Double
    let monthlyPayment: Double
}
