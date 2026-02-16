import SwiftUI

struct CompareMortgageSectionView: View {
    @ObservedObject var viewModel: CompareViewModel

    var body: some View {
        Section("Условия ипотеки") {
            LabeledSliderRow(title: "Первоначальный взнос", value: $viewModel.downPayment, range: 10...99, unit: "%")
            LabeledSliderRow(
                title: "Срок кредита",
                value: $viewModel.loanTerm,
                range: 1...30,
                unit: russianYears(Int(viewModel.loanTerm))
            )
            LabeledSliderRow(title: "Процент", value: $viewModel.interestRate, range: 2...30, unit: "%")
        }
        .disabled(!viewModel.canEditPropertyFields)
        .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
    }
}
