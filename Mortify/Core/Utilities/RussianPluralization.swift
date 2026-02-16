import Foundation

func russianYears(_ value: Int) -> String {
    let n = abs(value) % 100
    if n >= 11 && n <= 14 { return "лет" }
    switch n % 10 {
    case 1:
        return "год"
    case 2, 3, 4:
        return "года"
    default:
        return "лет"
    }
}
