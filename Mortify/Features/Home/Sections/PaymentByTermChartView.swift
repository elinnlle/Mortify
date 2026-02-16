import SwiftUI
import Charts

struct PaymentByTermChartView: View {
    let price: Double
    let downPayment: Double
    let interestRate: Double
    let loanTerm: Double

    private var data: [Point] {
        (5...30).map { years in
            let payment = MortgageCalculatorService.monthlyPayment(
                price: price,
                downPayment: downPayment,
                years: Double(years),
                rate: interestRate
            )
            return Point(years: years, payment: payment.isFinite ? payment : 0)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Платеж по сроку кредита")
                .font(.caption)
                .foregroundColor(.gray)

            Chart {
                ForEach(data) { item in
                    LineMark(
                        x: .value("Срок", item.years),
                        y: .value("Платеж", item.payment)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color("AccentColor"))

                    PointMark(
                        x: .value("Срок", item.years),
                        y: .value("Платеж", item.payment)
                    )
                    .foregroundStyle(Color("AccentColor"))
                }

                if loanTerm >= 5, loanTerm <= 30 {
                    RuleMark(x: .value("Текущий срок", Int(loanTerm.rounded())))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundStyle(Color("AccentColor"))
                }
            }
            .chartXAxis {
                AxisMarks(values: Array(stride(from: 5, through: 30, by: 5))) { value in
                    AxisValueLabel {
                        if let years = value.as(Int.self) {
                            Text("\(years) лет")
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text(formatCurrency(amount))
                        }
                    }
                }
            }
            .frame(height: 180)
        }
        .padding(.top, 8)
    }

    private func formatCurrency(_ value: Double) -> String {
        NumberFormatter.rubleNoKopecks.string(from: NSNumber(value: value)) ?? ""
    }

    private struct Point: Identifiable {
        let id = UUID()
        let years: Int
        let payment: Double
    }
}
