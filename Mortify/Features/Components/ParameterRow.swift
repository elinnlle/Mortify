import SwiftUI

struct ParameterRow: View {
    let title: String
    @Binding var value: String
    let unit: String
    var isInvalid: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isInvalid ? .red : .primary)
            Spacer()
            TextField("", text: $value)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
                .keyboardType(.decimalPad)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
                )
            Text(unit)
                .foregroundColor(.gray)
        }
    }
}
