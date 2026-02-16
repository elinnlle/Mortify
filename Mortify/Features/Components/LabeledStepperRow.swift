import SwiftUI

struct LabeledStepperRow: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let unit: String
    var isInvalid: Bool = false

    var body: some View {
        Stepper {
            HStack {
                Text(title)
                    .foregroundColor(isInvalid ? .red : .primary)
                Spacer()
                Text("\(value) \(unit)")
                    .foregroundColor(isInvalid ? .red : .primary)
            }
        } onIncrement: {
            if value < range.upperBound { value += 1 }
        } onDecrement: {
            if value > range.lowerBound { value -= 1 }
        }
    }
}
