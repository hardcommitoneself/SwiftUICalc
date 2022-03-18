import Foundation

class CalculationString {
    
    // MARK: Fields
    private var value: String
    
    // MARK: Properties
    var valueNumber: Decimal? {
        Decimal(string: value.replacingOccurrences(of: ",", with: "."))
    }
    
    required init(_ value: String) {
        self.value = value
    }
    
    // MARK: Public methods
    @discardableResult
    func validatedReplace(with text: String) -> String {
        if text == "," {
            value = "0" + text
        } else {
            value = text
        }
        
        return value
    }
    
    func validatedReplace(with number: Decimal) -> String {
        guard number != .nan else {
            value = "Error"
            return value
        }
        
        guard number.description.count < 10 else {
            value = number.scientificFormatted
            return value
        }
        
        value = String(describing: number)
            .replacingOccurrences(of: ".", with: ",")
        return value
    }
    
    func validatedAppend(text: String) -> String {
        guard value != "0" else {
            return validatedReplace(with: text)
        }
        
        guard value != "-0" else {
            validatedReplace(with: text)
            value.insert("-", at: value.startIndex)
            return value
        }
        
        if canAppend(text: text) {
            value += text
        }
        
        return value
    }
    
    func toggleTextSign() -> String {
        if value.first == "-" {
            value.removeFirst()
        } else {
            value.insert("-", at: value.startIndex)
        }
        
        return value
    }
    
    // MARK: Private methods
    private func canAppend(text: String) -> Bool {
        (text != "," || !value.contains(",")) && countDigits(in: value) < 9
    }
    
    private func countDigits(in text: String) -> Int {
        return text.replacingOccurrences(
            of: "[,-]",
            with: "",
            options: .regularExpression).count
    }
}
