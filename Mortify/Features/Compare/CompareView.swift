import SwiftUI

struct CompareView: View {
    @StateObject private var viewModel = CompareViewModel()

    var body: some View {
        Form {
            CompareRegionSectionView(viewModel: viewModel)
            CompareVariantSectionView(
                title: "Вариант A",
                variant: $viewModel.variantA,
                isEnabled: viewModel.canEditPropertyFields,
                invalidFields: viewModel.invalidFieldsA
            )
            CompareVariantSectionView(
                title: "Вариант B",
                variant: $viewModel.variantB,
                isEnabled: viewModel.canEditPropertyFields,
                invalidFields: viewModel.invalidFieldsB
            )
            CompareMortgageSectionView(viewModel: viewModel)
            CompareSummarySectionView(viewModel: viewModel)
        }
        .navigationTitle("Сравнение")
        .onAppear { viewModel.recalculate() }
        .onChange(of: viewModel.inputSignature) { _, _ in
            viewModel.recalculate()
        }
    }
}
