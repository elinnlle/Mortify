import Foundation

extension NumberFormatter {
    static let rubleNoKopecks: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "₽"
        f.maximumFractionDigits = 0
        f.locale = Locale(identifier: "ru_RU")
        f.groupingSeparator = " "
        return f
    }()
}
