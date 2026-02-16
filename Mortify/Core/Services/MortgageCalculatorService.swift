import Foundation
import CoreML

struct MortgageCalculatorService {
    private static let sharedModel: MoscowHousePricePredictor? = {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            return try MoscowHousePricePredictor(configuration: config)
        } catch {
            return nil
        }
    }()

    static func predictPrice(input: PropertyInput) -> Double {
        guard let model = sharedModel else {
            return fallbackPrice(input: input)
        }

        let floorsTotalSafe = max(input.floorsTotal, 1)
        let relativeFloor = Double(input.floor) / Double(floorsTotalSafe)
        let isFirstFloor: Int64 = input.floor == 1 ? 1 : 0
        let isLastFloor: Int64 = input.floor == floorsTotalSafe ? 1 : 0
        let roomsCat: Int64 = input.rooms >= 4 ? 4 : Int64(max(input.rooms, 1))

        let modelInput = MoscowHousePricePredictorInput(
            Apartment_type: input.apartmentType.rawValue,
            Minutes_to_metro: input.minutesToMetro,
            Area: input.area,
            Living_area: input.livingArea,
            Kitchen_area: input.kitchenArea,
            Renovation: input.renovation.rawValue,
            distance_to_kremlin_km: input.centerDistanceKm,
            RelativeFloor: relativeFloor,
            IsFirstFloor: isFirstFloor,
            IsLastFloor: isLastFloor,
            RoomsCat: roomsCat
        )

        let pricePerM2 = (try? model.prediction(input: modelInput).PricePerM2) ?? 0

        let price = pricePerM2 * input.area
        return price.isFinite ? price : 0
    }

    static func monthlyPayment(
        price: Double,
        downPayment: Double,
        years: Double,
        rate: Double
    ) -> Double {
        guard price > 0, years > 0 else { return 0 }
        let loan = price * (100 - downPayment) / 100
        let r = rate / 100 / 12
        let n = years * 12

        guard r > 0 else { return loan / n }

        let k = pow(1 + r, n)
        let payment = loan * (r * k) / (k - 1)
        return payment.isFinite ? payment : 0
    }

    static func totalOverpayment(
        price: Double,
        downPayment: Double,
        years: Double,
        monthlyPayment: Double
    ) -> Double {
        let loan = price * (100 - downPayment) / 100
        let total = monthlyPayment * years * 12
        let overpayment = total - loan
        return overpayment.isFinite ? overpayment : 0
    }

    private static func fallbackPrice(input: PropertyInput) -> Double {
        let base = input.area * 220_000
        let livingBonus = input.livingArea * 80_000
        let kitchenBonus = input.kitchenArea * 50_000
        let price = base + livingBonus + kitchenBonus
        return price.isFinite ? max(price, 0) : 0
    }
}
