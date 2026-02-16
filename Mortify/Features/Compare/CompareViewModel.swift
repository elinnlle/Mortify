import Foundation

final class CompareViewModel: ObservableObject {
    enum Field: Hashable {
        case area
        case livingArea
        case kitchenArea
        case minutesToMetro
        case centerDistanceKm
        case rooms
        case floor
        case floorsTotal
    }
    @Published var variantA = CompareVariantState()
    @Published var variantB = CompareVariantState()

    @Published var loanTerm = 20.0
    @Published var downPayment = 20.0
    @Published var interestRate = 7.5
    @Published var selectedRegion: Region = RegionStore.regions[0]

    @Published private(set) var priceA: Double = 0
    @Published private(set) var priceB: Double = 0
    @Published private(set) var paymentA: Double = 0
    @Published private(set) var paymentB: Double = 0
    @Published private(set) var overpayA: Double = 0
    @Published private(set) var overpayB: Double = 0
    @Published private(set) var invalidFieldsA: Set<Field> = []
    @Published private(set) var invalidFieldsB: Set<Field> = []

    private var workItem: DispatchWorkItem?

    init() {}

    var inputSignature: String {
        [
            variantA.signature,
            variantB.signature,
            "\(loanTerm)",
            "\(downPayment)",
            "\(interestRate)",
            selectedRegion.id
        ].joined(separator: "|")
    }

    var canEditPropertyFields: Bool {
        selectedRegion.isEnabled
    }

    private func calculatePrice(for state: CompareVariantState) -> Double {
        if !collectInvalidFields(for: state).isEmpty { return 0 }
        guard let input = makeInput(from: state) else { return 0 }
        return MortgageCalculatorService.predictPrice(input: input)
    }

    func recalculate() {
        workItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            self?.calculateNow()
        }
        workItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: item)
    }

    private func calculateNow() {
        if !selectedRegion.isEnabled {
            priceA = 0
            priceB = 0
            paymentA = 0
            paymentB = 0
            overpayA = 0
            overpayB = 0
            invalidFieldsA = collectInvalidFields(for: variantA)
            invalidFieldsB = collectInvalidFields(for: variantB)
            return
        }

        invalidFieldsA = collectInvalidFields(for: variantA)
        invalidFieldsB = collectInvalidFields(for: variantB)

        let pA = calculatePrice(for: variantA)
        let pB = calculatePrice(for: variantB)
        priceA = pA
        priceB = pB

        paymentA = MortgageCalculatorService.monthlyPayment(
            price: pA,
            downPayment: downPayment,
            years: loanTerm,
            rate: interestRate
        )
        paymentB = MortgageCalculatorService.monthlyPayment(
            price: pB,
            downPayment: downPayment,
            years: loanTerm,
            rate: interestRate
        )

        overpayA = MortgageCalculatorService.totalOverpayment(
            price: pA,
            downPayment: downPayment,
            years: loanTerm,
            monthlyPayment: paymentA
        )
        overpayB = MortgageCalculatorService.totalOverpayment(
            price: pB,
            downPayment: downPayment,
            years: loanTerm,
            monthlyPayment: paymentB
        )
    }

    private func makeInput(from state: CompareVariantState) -> PropertyInput? {
        guard
            let area = parseDouble(state.area),
            let livingArea = parseDouble(state.livingArea),
            let kitchenArea = parseDouble(state.kitchenArea),
            let minutesToMetro = parseDouble(state.minutesToMetro),
            let centerDistanceKm = parseDouble(state.centerDistanceKm)
        else { return nil }

        guard state.floorsTotal > 0, state.floor > 0 else { return nil }

        return PropertyInput(
            area: area,
            livingArea: livingArea,
            kitchenArea: kitchenArea,
            minutesToMetro: minutesToMetro,
            centerDistanceKm: centerDistanceKm,
            rooms: state.rooms,
            floor: state.floor,
            floorsTotal: state.floorsTotal,
            renovation: state.renovation,
            apartmentType: state.apartmentType
        )
    }

    private func collectInvalidFields(for state: CompareVariantState) -> Set<Field> {
        var fields = Set<Field>()

        if parseDouble(state.area) == nil { fields.insert(.area) }
        if parseDouble(state.livingArea) == nil { fields.insert(.livingArea) }
        if parseDouble(state.kitchenArea) == nil { fields.insert(.kitchenArea) }
        if parseDouble(state.minutesToMetro) == nil { fields.insert(.minutesToMetro) }
        if parseDouble(state.centerDistanceKm) == nil { fields.insert(.centerDistanceKm) }

        if state.rooms <= 0 { fields.insert(.rooms) }
        if state.floor <= 0 { fields.insert(.floor) }
        if state.floorsTotal <= 0 { fields.insert(.floorsTotal) }
        if state.floor > state.floorsTotal { fields.insert(.floor); fields.insert(.floorsTotal) }

        return fields
    }
}
