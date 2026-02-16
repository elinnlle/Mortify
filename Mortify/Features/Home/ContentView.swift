import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel
    @StateObject private var historyViewModel: HistoryViewModel
    @State private var showHistory = false
    @State private var showCompare = false

    init() {
        let store = HistoryStore()
        _viewModel = StateObject(wrappedValue: ContentViewModel(historyStore: store))
        _historyViewModel = StateObject(wrappedValue: HistoryViewModel(store: store))
    }

    var body: some View {
        NavigationView {
            Form {
                PropertySectionView(viewModel: viewModel)
                MortgageSectionView(viewModel: viewModel)
                ResultSectionView(viewModel: viewModel)
            }
            .navigationTitle("Расчёт стоимости")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { viewModel.onAppear() }
            .onChange(of: viewModel.inputSignature) { _, _ in
                viewModel.onInputChanged()
            }
            .onChange(of: viewModel.mortgageSignature) { _, _ in
                viewModel.onMortgageChanged()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .accessibilityLabel("История")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCompare = true
                    } label: {
                        Image(systemName: "rectangle.split.2x1")
                    }
                    .accessibilityLabel("Сравнить")
                }
            }
            .sheet(isPresented: $showHistory) {
                HistoryView(viewModel: historyViewModel)
            }
            .sheet(isPresented: $showCompare) {
                NavigationView { CompareView() }
            }
        }
    }
}
