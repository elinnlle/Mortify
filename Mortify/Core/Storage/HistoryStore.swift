import Foundation

final class HistoryStore: ObservableObject {
    @Published var items: [CalculationRecord] = []
    private let key = "mortgage_history_v1"

    init() {
        load()
    }

    func add(_ record: CalculationRecord) {
        items.insert(record, at: 0)
        save()
    }

    func delete(_ offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func clear() {
        items.removeAll()
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([CalculationRecord].self, from: data) {
            items = decoded
        }
    }

    private func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
