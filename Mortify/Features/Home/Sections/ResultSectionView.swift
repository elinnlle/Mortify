import SwiftUI

struct ResultSectionView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        Section("Результат") {
            if !viewModel.canEditPropertyFields {
                Label("Сейчас доступны только данные для Москвы", systemImage: "sparkles")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else if let error = viewModel.error {
                Text(error).foregroundColor(.orange)
            } else if let price = viewModel.price {
                PredictionResultView(
                    price: price,
                    monthlyPayment: viewModel.payment,
                    downPayment: viewModel.downPayment,
                    loanTerm: viewModel.loanTerm,
                    interestRate: viewModel.interestRate
                )

                PaymentByTermChartView(
                    price: price,
                    downPayment: viewModel.downPayment,
                    interestRate: viewModel.interestRate,
                    loanTerm: viewModel.loanTerm
                )

                Button("Сохранить в историю") {
                    viewModel.saveToHistory()
                }
                .disabled(!viewModel.canSave)
            } else {
                Text("Введите параметры")
            }
        }
    }
}
