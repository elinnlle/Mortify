import Combine
import Foundation

final class HistoryViewModel: ObservableObject {
    @Published private(set) var items: [CalculationRecord] = []

    private let store: HistoryStore
    private var cancellables = Set<AnyCancellable>()

    init(store: HistoryStore) {
        self.store = store
        self.items = store.items
        store.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.items = $0 }
            .store(in: &cancellables)
    }

    func delete(_ offsets: IndexSet) {
        store.delete(offsets)
    }

    func clear() {
        store.clear()
    }
}
