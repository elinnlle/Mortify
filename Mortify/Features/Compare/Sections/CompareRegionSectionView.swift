import SwiftUI

struct CompareRegionSectionView: View {
    @ObservedObject var viewModel: CompareViewModel

    var body: some View {
        Section("Регион") {
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
