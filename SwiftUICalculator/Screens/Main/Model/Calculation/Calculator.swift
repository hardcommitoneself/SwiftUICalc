import Foundation

class Calculator {
    
    private(set) var calculationText: String
    
    private var currentResult: Decimal
    private var lastSecondaryOperation: OperationType
    private var storedNumber: Decimal
    private var storedOperation: OperationType
    
    private var state: State
    
    init() {
        state = BeforeCalculationState()
        calculationText = "0"
        currentResult = 0
        storedNumber = 0
        lastSecondaryOperation = .plus
        storedOperation = .plus
    }
    
    func handleDigit(withValue digit: String) {
        transitionTo(state: state.handleNumber(calculator: self, withValue: digit))
    }
    
    func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        transitionTo(state: state.handleUnaryOperation(calculator: self,
                                                       ofType: type,
                                                       number: number))
    }
    
    func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        transitionTo(state: state.handlePrimaryOperation(calculator: self,
                                                         ofType: type,
                                                         number: number))
    }
    
    func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        transitionTo(state: state.handleSecondaryOperation(calculator: self,
                                                           ofType: type,
                                                           number: number))
    }
    
    func handleEqualOperation(number: Decimal? = nil) {
        transitionTo(state: state.handleEqualOperation(calculator: self, number: number))
    }
    
    // MARK: Service methods
    private func performOperation(ofType type: OperationType,
                                  withSecondNumber number: Decimal?) -> Decimal {
        return type.performOperation(num1: currentResult,
                                     num2: number ?? storedNumber)
    }
}

extension Calculator {
    func transitionTo(state: State?) {
        guard let state = state else { return }
        self.state = state
    }
    
    func isStoredOperationPrimary() -> Bool {
        storedOperation == .multiply || storedOperation == .division
    }
    
    func replaceText(with text: String) {
        if text == "," {
            calculationText = "0" + text
        } else {
            calculationText = text
        }
    }
    
    func appendText(_ text: String) {
        if calculationText == "0" {
            replaceText(with: text)
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
    
    /// Calculate stored operation and then last stored secondary operation.
    /// If second number is nil, operation will be performed with stored number
    func calculateMultipleOperations(secondNumber: Decimal?) -> Decimal {
        let tempNumber = storedOperation.performOperation(
            num1: storedNumber,
            num2: secondNumber ?? storedNumber)
        return performOperation(ofType: lastSecondaryOperation,
                                withSecondNumber: tempNumber)
    }
    
    /// Calculate stored operation.
    /// If second number is nil, operation will be performed with stored number
    func calculateStoredOperation(secondNumber: Decimal?) -> Decimal {
        return performOperation(ofType: storedOperation,
                                withSecondNumber: secondNumber)
    }
    
    /// Calculate last stored secondary operation.
    /// If second number is nil, operation will be performed with stored number
    func calculateSecondaryOperation(secondNumber: Decimal?) -> Decimal {
        return performOperation(ofType: lastSecondaryOperation,
                                withSecondNumber: secondNumber)
    }
    
    /// Function to store new entered numbers and operations.
    /// If any parameter is nil, it will not be stored.
    func storeCalculationInfo(result: Decimal? = nil,
                              numberToStore storedNumber: Decimal? = nil,
                              operationToStore storedOperation: OperationType? = nil,
                              secondaryOperation: OperationType? = nil) {
        if let result = result {
            currentResult = result
        }
        
        if let storedNumber = storedNumber {
            self.storedNumber = storedNumber
        }
        
        if let storedOperation = storedOperation {
            self.storedOperation = storedOperation
        }
        
        if let secondaryOperation = secondaryOperation {
            lastSecondaryOperation = secondaryOperation
        }
    }
}
