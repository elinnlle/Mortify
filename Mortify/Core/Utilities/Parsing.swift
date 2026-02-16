import Foundation

func parseDouble(_ value: String) -> Double? {
    Double(value.trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: ",", with: "."))
}
