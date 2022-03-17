import Foundation

extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? "Error"
    }
}
