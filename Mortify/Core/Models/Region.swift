import Foundation

struct Region: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let isEnabled: Bool
}

enum RegionStore {
    static let regions: [Region] = [
        Region(id: "moscow", title: "Москва", isEnabled: true),
        Region(id: "spb", title: "Санкт-Петербург", isEnabled: false),
        Region(id: "kazan", title: "Казань", isEnabled: false),
        Region(id: "ekb", title: "Екатеринбург", isEnabled: false)
    ]

    static func regionTitle(for id: String) -> String {
        regions.first(where: { $0.id == id })?.title ?? id
    }
}
