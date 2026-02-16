import SwiftUI

struct ApartmentTypePickerRow: View {
    @Binding var value: ApartmentType

    var body: some View {
        HStack {
            Text("Тип жилья")
            Spacer()
            Picker("", selection: $value) {
                ForEach(ApartmentType.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            .labelsHidden()
        }
    }
}
