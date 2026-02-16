import Foundation

enum Renovation: String, CaseIterable, Identifiable, Codable {
    case withoutRenovation = "Without renovation"
    case cosmetic = "Cosmetic"
    case europeanStyle = "European-style renovation"
    case designer = "Designer"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .withoutRenovation:
            return "Без ремонта"
        case .cosmetic:
            return "Косметический"
        case .europeanStyle:
            return "Евроремонт"
        case .designer:
            return "Дизайнерский"
        }
    }
}
