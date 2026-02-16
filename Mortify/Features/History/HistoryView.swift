import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel

    private var formatter: NumberFormatter { .rubleNoKopecks }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    HistoryRowView(item: item, formatter: formatter)
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("История")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Очистить") { viewModel.clear() }
                        .disabled(viewModel.items.isEmpty)
                }
            }
        }
    }
}
