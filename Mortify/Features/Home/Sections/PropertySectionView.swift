import SwiftUI

struct PropertySectionView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        Section("Характеристики недвижимости") {
            regionRow()
            ParameterRow(title: "Площадь", value: $viewModel.area, unit: "м²", isInvalid: viewModel.invalidFields.contains(.area))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            ParameterRow(title: "Жилая", value: $viewModel.livingArea, unit: "м²", isInvalid: viewModel.invalidFields.contains(.livingArea))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            ParameterRow(title: "Кухня", value: $viewModel.kitchenArea, unit: "м²", isInvalid: viewModel.invalidFields.contains(.kitchenArea))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            ParameterRow(title: "До метро", value: $viewModel.minutesToMetro, unit: "мин", isInvalid: viewModel.invalidFields.contains(.minutesToMetro))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            ParameterRow(title: "Удалённость от центра", value: $viewModel.distanceToKremlin, unit: "км", isInvalid: viewModel.invalidFields.contains(.centerDistanceKm))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            LabeledStepperRow(title: "Комнаты", value: $viewModel.rooms, range: 1...10, unit: "шт", isInvalid: viewModel.invalidFields.contains(.rooms))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            LabeledStepperRow(title: "Этаж", value: $viewModel.floor, range: 1...60, unit: "эт", isInvalid: viewModel.invalidFields.contains(.floor))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            LabeledStepperRow(title: "Этажность", value: $viewModel.floorsTotal, range: 1...60, unit: "эт", isInvalid: viewModel.invalidFields.contains(.floorsTotal))
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            ApartmentTypePickerRow(value: $viewModel.apartmentType)
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
            RenovationPickerRow(value: $viewModel.renovation)
                .disabled(!viewModel.canEditPropertyFields)
                .opacity(viewModel.canEditPropertyFields ? 1 : 0.5)
        }
    }

    private func regionRow() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Регион")
                Spacer()
                Picker("", selection: $viewModel.selectedRegion) {
                    ForEach(RegionStore.regions) { region in
                        Text(region.title)
                            .tag(region)
                            .disabled(!region.isEnabled)
                    }
                }
                .labelsHidden()
            }

            if !viewModel.selectedRegion.isEnabled {
                Label("Сейчас доступны только данные для Москвы", systemImage: "sparkles")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
