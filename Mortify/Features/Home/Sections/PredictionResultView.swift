import SwiftUI

struct PredictionResultView: View {
    let price: Double
    let monthlyPayment: Double?
    let downPayment: Double
    let loanTerm: Double
    let interestRate: Double

    private var formatter: NumberFormatter { .rubleNoKopecks }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Прогнозируемая стоимость")
                .font(.caption)
                .foregroundColor(.gray)

            Text(formatter.string(from: NSNumber(value: price)) ?? "")
                .font(.title2)
                .bold()
                .foregroundColor(Color("AccentColor"))

            Divider()

            if let payment = monthlyPayment {
                let credit = price * (100 - downPayment) / 100
                let total = payment * loanTerm * 12
                let overpay = total - credit

                VStack(alignment: .leading, spacing: 8) {
                    row("Первоначальный взнос", "\(Int(downPayment))%")
                    row("Сумма кредита", formatter.string(from: NSNumber(value: credit)) ?? "")
                    row("Ежемесячный платеж",
                        formatter.string(from: NSNumber(value: payment)) ?? "",
                        color: .green)

                    row("Переплата за \(Int(loanTerm)) лет",
                        formatter.string(from: NSNumber(value: overpay)) ?? "",
                        color: .red)
                }
            }
        }
    }

    private func row(_ title: String, _ value: String, color: Color = .primary) -> some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Text(value).foregroundColor(color).bold()
        }
    }
}
