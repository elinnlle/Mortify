import SwiftUI

struct MortgageSectionView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var showDownPaymentHint = false

    var body: some View {
        Section("Условия ипотеки") {
            LabeledSliderRow(
                title: "Первоначальный взнос",
                value: $viewModel.downPayment,
                range: 10...99,
                unit: "%"
            ) { editing in
                showDownPaymentHint = editing
            }
            .popover(isPresented: $showDownPaymentHint) {
                downPaymentHint()
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .frame(minWidth: 260)
                    .presentationCompactAdaptation(.popover)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
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

    private func downPaymentHint() -> some View {
        let amount = (viewModel.price ?? 0) * viewModel.downPayment / 100
        let text = NumberFormatter.rubleNoKopecks.string(from: NSNumber(value: amount)) ?? ""
        return HStack {
            Text("Сумма взноса")
                .font(.callout)
                .foregroundColor(Color("AccentColor"))
            Spacer()
            Text(text)
                .font(.callout)
                .foregroundColor(Color("AccentColor"))
        }
    }
}
