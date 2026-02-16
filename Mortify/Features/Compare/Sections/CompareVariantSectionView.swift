import SwiftUI

struct CompareVariantSectionView: View {
    let title: String
    @Binding var variant: CompareVariantState
    let isEnabled: Bool
    let invalidFields: Set<CompareViewModel.Field>

    var body: some View {
        Section(title) {
            ParameterRow(title: "Площадь", value: $variant.area, unit: "м²", isInvalid: invalidFields.contains(.area))
            ParameterRow(title: "Жилая", value: $variant.livingArea, unit: "м²", isInvalid: invalidFields.contains(.livingArea))
            ParameterRow(title: "Кухня", value: $variant.kitchenArea, unit: "м²", isInvalid: invalidFields.contains(.kitchenArea))
            ParameterRow(title: "До метро", value: $variant.minutesToMetro, unit: "мин", isInvalid: invalidFields.contains(.minutesToMetro))
            ParameterRow(title: "До центра", value: $variant.centerDistanceKm, unit: "км", isInvalid: invalidFields.contains(.centerDistanceKm))
            LabeledStepperRow(title: "Комнаты", value: $variant.rooms, range: 1...10, unit: "шт", isInvalid: invalidFields.contains(.rooms))
            LabeledStepperRow(title: "Этаж", value: $variant.floor, range: 1...60, unit: "эт", isInvalid: invalidFields.contains(.floor))
            LabeledStepperRow(title: "Этажность", value: $variant.floorsTotal, range: 1...60, unit: "эт", isInvalid: invalidFields.contains(.floorsTotal))
            ApartmentTypePickerRow(value: $variant.apartmentType)
            RenovationPickerRow(value: $variant.renovation)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.5)
    }
}
