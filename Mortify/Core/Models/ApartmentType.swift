import Foundation

enum ApartmentType: String, CaseIterable, Identifiable, Codable {
    case newBuilding = "New building"
    case secondary = "Secondary"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newBuilding:
            return "Новостройка"
        case .secondary:
            return "Вторичка"
        }
    }
}
