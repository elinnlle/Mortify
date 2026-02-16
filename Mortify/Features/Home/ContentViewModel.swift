import Foundation

final class ContentViewModel: ObservableObject {
    enum PropertyField: Hashable {
        case area
        case livingArea
        case kitchenArea
        case minutesToMetro
        case centerDistanceKm
        case rooms
        case floor
        case floorsTotal
    }
    @Published var area = "75"
    @Published var livingArea = "45"
    @Published var kitchenArea = "12"
    @Published var minutesToMetro = "10"
    @Published var distanceToKremlin = "8"

    @Published var rooms = 3
    @Published var floor = 5
    @Published var floorsTotal = 12
    @Published var renovation: Renovation = .cosmetic
    @Published var apartmentType: ApartmentType = .secondary

    @Published var loanTerm = 20.0
    @Published var downPayment = 20.0
    @Published var interestRate = 7.5

    @Published var price: Double?
    @Published var payment: Double?
    @Published var error: String?
    @Published var selectedRegion: Region
    @Published private(set) var invalidFields: Set<PropertyField> = []

    let historyStore: HistoryStore

    private var workItem: DispatchWorkItem?
    private var calculationToken = UUID()

    init(historyStore: HistoryStore, initialRegion: Region = RegionStore.regions[0]) {
        self.historyStore = historyStore
        self.selectedRegion = initialRegion
    }

    var inputSignature: String {
        [
            area,
            livingArea,
            kitchenArea,
            minutesToMetro,
            distanceToKremlin,
            String(rooms),
            String(floor),
            String(floorsTotal),
            renovation.rawValue,
            apartmentType.rawValue,
            selectedRegion.id
        ].joined(separator: "|")
    }

    var mortgageSignature: String {
        "\(downPayment)|\(loanTerm)|\(interestRate)"
    }

    var canEditPropertyFields: Bool {
        selectedRegion.isEnabled
    }

    var canSave: Bool {
        selectedRegion.isEnabled &&
        buildPropertyInput() != nil &&
        invalidFields.isEmpty &&
        price != nil &&
        payment != nil
    }

    func onAppear() {
        debouncedCalc()
    }

    func onInputChanged() {
        updateValidationState()
        debouncedCalc()
    }

    func onMortgageChanged() {
        recalcMortgage()
    }

    func saveToHistory() {
        guard
            let payment = payment,
            let input = buildPropertyInput(),
            let price = price
        else { return }

        let record = CalculationRecord(
            id: UUID(),
            date: Date(),
            regionId: selectedRegion.id,
            regionTitle: selectedRegion.title,
            area: input.area,
            livingArea: input.livingArea,
            kitchenArea: input.kitchenArea,
            minutesToMetro: input.minutesToMetro,
            centerDistanceKm: input.centerDistanceKm,
            rooms: input.rooms,
            floor: input.floor,
            floorsTotal: input.floorsTotal,
            renovationRaw: input.renovation.rawValue,
            apartmentTypeRaw: input.apartmentType.rawValue,
            loanTermYears: loanTerm,
            downPaymentPercent: downPayment,
            interestRatePercent: interestRate,
            predictedPrice: price,
            monthlyPayment: payment
        )

        historyStore.add(record)
    }

    func buildPropertyInput() -> PropertyInput? {
        guard
            let area = parseDouble(area),
            let livingArea = parseDouble(livingArea),
            let kitchenArea = parseDouble(kitchenArea),
            let minutesToMetro = parseDouble(minutesToMetro),
            let centerDistanceKm = parseDouble(distanceToKremlin)
        else { return nil }

        guard floorsTotal > 0, floor > 0 else { return nil }

        return PropertyInput(
            area: area,
            livingArea: livingArea,
            kitchenArea: kitchenArea,
            minutesToMetro: minutesToMetro,
            centerDistanceKm: centerDistanceKm,
            rooms: rooms,
            floor: floor,
            floorsTotal: floorsTotal,
            renovation: renovation,
            apartmentType: apartmentType
        )
    }

    private func debouncedCalc() {
        workItem?.cancel()
        let token = UUID()
        calculationToken = token
        let item = DispatchWorkItem { [weak self] in
            self?.calculate(token: token)
        }
        workItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
    }

    private func calculate(token: UUID) {
        if !selectedRegion.isEnabled {
            error = "На данный момент расчёты доступны только для Москвы"
            price = nil
            payment = nil
            return
        }

        updateValidationState()
        guard let input = buildPropertyInput(), invalidFields.isEmpty else {
            error = validationMessage()
            price = 0
            payment = 0
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let p = MortgageCalculatorService.predictPrice(input: input)
            let m = MortgageCalculatorService.monthlyPayment(
                price: p,
                downPayment: self?.downPayment ?? 0,
                years: self?.loanTerm ?? 0,
                rate: self?.interestRate ?? 0
            )

            DispatchQueue.main.async {
                guard let self, token == self.calculationToken else { return }
                self.price = p
                self.payment = m
                self.error = nil
            }
        }
    }

    private func recalcMortgage() {
        guard let price = price else { return }
        payment = MortgageCalculatorService.monthlyPayment(
            price: price,
            downPayment: downPayment,
            years: loanTerm,
            rate: interestRate
        )
    }

    private func updateValidationState() {
        let fields = collectInvalidFields()
        if fields != invalidFields {
            invalidFields = fields
        }
    }

    private func collectInvalidFields() -> Set<PropertyField> {
        var fields = Set<PropertyField>()

        if parseDouble(area) == nil { fields.insert(.area) }
        if parseDouble(livingArea) == nil { fields.insert(.livingArea) }
        if parseDouble(kitchenArea) == nil { fields.insert(.kitchenArea) }
        if parseDouble(minutesToMetro) == nil { fields.insert(.minutesToMetro) }
        if parseDouble(distanceToKremlin) == nil { fields.insert(.centerDistanceKm) }

        if rooms <= 0 { fields.insert(.rooms) }
        if floor <= 0 { fields.insert(.floor) }
        if floorsTotal <= 0 { fields.insert(.floorsTotal) }
        if floor > floorsTotal { fields.insert(.floor); fields.insert(.floorsTotal) }

        return fields
    }

    private func validationMessage() -> String? {
        if invalidFields.isEmpty { return nil }

        var labels: [String] = []
        if invalidFields.contains(.area) { labels.append("площадь") }
        if invalidFields.contains(.livingArea) { labels.append("жилая площадь") }
        if invalidFields.contains(.kitchenArea) { labels.append("площадь кухни") }
        if invalidFields.contains(.minutesToMetro) { labels.append("время до метро") }
        if invalidFields.contains(.centerDistanceKm) { labels.append("удалённость от центра") }
        if invalidFields.contains(.rooms) { labels.append("комнаты") }
        if invalidFields.contains(.floor) { labels.append("этаж") }
        if invalidFields.contains(.floorsTotal) { labels.append("этажность") }

        if labels.isEmpty { return "Проверьте введённые данные" }
        return "Проверьте: " + labels.joined(separator: ", ")
    }
}
