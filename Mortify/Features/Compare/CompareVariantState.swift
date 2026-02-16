import Foundation

struct CompareVariantState {
    var area = "65"
    var livingArea = "30"
    var kitchenArea = "15"
    var minutesToMetro = "10"
    var centerDistanceKm = "5"
    var rooms = 2
    var floor = 10
    var floorsTotal = 25
    var renovation: Renovation = .cosmetic
    var apartmentType: ApartmentType = .secondary

    var signature: String {
        [
            area,
            livingArea,
            kitchenArea,
            minutesToMetro,
            centerDistanceKm,
            String(rooms),
            String(floor),
            String(floorsTotal),
            renovation.rawValue,
            apartmentType.rawValue
        ].joined(separator: "|")
    }
}
