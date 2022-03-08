import Foundation

class Calculator {
    
    private var state: State
    
    var calculationText: String
    
    var currentResult: Decimal
    var lastSecondaryOperation: OperationType
    var storedNumber: Decimal
    var storedOperation: OperationType
    
    init(_ state: State) {
        self.state = state
        calculationText = "0"
        currentResult = 0
        storedNumber = 0
        lastSecondaryOperation = .plus
        storedOperation = .plus
        state.update(context: self)
    }
    
    func transitionTo(state: State) {
        state.update(context: self)
        self.state = state
    }
    
    func handleDigit(withValue digit: String) {
        state.handleNumber(withValue: digit)
    }
    
    func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        state.handleUnaryOperation(ofType: type, number: number)
    }
    
    func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        state.handlePrimaryOperation(ofType: type, number: number)
    }
    
    func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        state.handleSecondaryOperation(ofType: type, number: number)
    }
    
    func handleEqualOperation(number: Decimal? = nil) {
        state.handleEqualOperation(number: number)
    }
    
    // MARK: Service methods
    func replaceCurrentText(with text: String) {
        if text == "," {
            calculationText = "0" + text
        } else {
            calculationText = text
        }
    }
    
    func appendText(_ text: String) {
        if calculationText == "0" {
            replaceCurrentText(with: text)
        } else {
            if (text != "," || !calculationText.contains(","))
                && calculationText.count < 9 {
                calculationText += text
            }
        }
    }
    
    func updateCalculationText(with number: Decimal? = nil) {
        calculationText = String(describing: number ?? currentResult)
    }
    
    func storeCalculationInfo(withSecondaryOperation shouldStore: Bool,
                              operation: OperationType,
                              number: Decimal?) {
        currentResult = number ?? 0
        storedNumber = currentResult
        lastSecondaryOperation = shouldStore ? operation : lastSecondaryOperation
        storedOperation = operation
    }
    
    func calculateAndStoreNewInfo(withSecondaryOperation shouldStore: Bool,
                                  operation: OperationType,
                                  number: Decimal?) {
        calculateIntoResult(withNumber: number)
        storeCalculationInfo(
            withSecondaryOperation: shouldStore,
            operation: operation,
            number: number)
    }
    
    func calculateIntoResult(withNumber number: Decimal?) {
        currentResult = storedOperation.performOperation(
            num1: currentResult,
            num2: storedNumber)
    }
}
