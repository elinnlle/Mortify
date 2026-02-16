import SwiftUI

struct CompareSummarySectionView: View {
    @ObservedObject var viewModel: CompareViewModel

    private var formatter: NumberFormatter { .rubleNoKopecks }

    var body: some View {
        Section("Сравнение") {
            if !viewModel.canEditPropertyFields {
                Label("Сейчас доступны только данные для Москвы", systemImage: "sparkles")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                comparisonBlock(title: "Цена", valueA: viewModel.priceA, valueB: viewModel.priceB)
                comparisonBlock(title: "Платёж", valueA: viewModel.paymentA, valueB: viewModel.paymentB)
                comparisonBlock(title: "Переплата", valueA: viewModel.overpayA, valueB: viewModel.overpayB)
            }
        }
    }

    private func comparisonBlock(title: String, valueA: Double, valueB: Double) -> some View {
        let diff = valueA - valueB
        return VStack(alignment: .leading, spacing: 6) {
            Text(title).bold()
            HStack {
                Text("A")
                Spacer()
                Text(formatter.string(from: NSNumber(value: valueA)) ?? "")
            }
            HStack {
                Text("B")
                Spacer()
                Text(formatter.string(from: NSNumber(value: valueB)) ?? "")
            }
            HStack {
                Text("Δ")
                Spacer()
                Text(formatDiff(diff))
                    .foregroundColor(diff >= 0 ? .green : .red)
            }
        }
    }

    private func formatDiff(_ value: Double) -> String {
        let raw = formatter.string(from: NSNumber(value: abs(value))) ?? ""
        return value >= 0 ? "\(raw)" : "\(raw)"
    }
}
