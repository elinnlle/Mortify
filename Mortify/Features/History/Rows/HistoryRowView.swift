import SwiftUI

struct HistoryRowView: View {
    let item: CalculationRecord
    let formatter: NumberFormatter

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(DateFormatter.russianDayMonthYear.string(from: item.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(item.regionTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(summary)
                .font(.subheadline)

            HStack {
                Text(formatter.string(from: NSNumber(value: item.predictedPrice)) ?? "")
                    .bold()
                Spacer()
                Text(formatter.string(from: NSNumber(value: item.monthlyPayment)) ?? "")
                    .foregroundColor(.green)
                    .bold()
            }
        }
        .padding(.vertical, 4)
    }

    private var summary: String {
        "\(Int(item.area)) м² · \(item.rooms) комн · \(item.floor)/\(item.floorsTotal) этаж"
    }
}
