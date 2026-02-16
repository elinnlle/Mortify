import SwiftUI

struct LabeledSliderRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String
    var onEditingChanged: ((Bool) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(Int(value)) \(unit)")
            Slider(value: $value, in: range, onEditingChanged: { editing in
                onEditingChanged?(editing)
            })
        }
    }
}
