import SwiftUI

struct RenovationPickerRow: View {
    @Binding var value: Renovation

    var body: some View {
        HStack {
            Text("Ремонт")
            Spacer()
            Picker("", selection: $value) {
                ForEach(Renovation.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            .labelsHidden()
        }
    }
}
