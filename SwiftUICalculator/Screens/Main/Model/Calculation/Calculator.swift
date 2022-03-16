import Foundation

protocol CalculatorDelegate: AnyObject {
    func replaceText(with text: String)
    func appendText(_ text: String)
    func updateCalculationText(with number: Decimal)
}

class Calculator {
    
    weak var delegate: CalculatorDelegate?
    
    private var currentResult: Decimal
    private var storedNumber: Decimal
    private var lastSecondaryOperation: OperationType
    private var storedOperation: OperationType
    
    private var state: State
    
    init() {
        state = BeforeCalculationState()
        currentResult = 0
        storedNumber = 0
        lastSecondaryOperation = .plus
        storedOperation = .plus
    }
    
    // MARK: Handling input methods
    func handleDigit(withValue digit: String) {
        transitionTo(state: state.handleDigit(calculator: self, withValue: digit))
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
    
    // MARK: Public service methods
    func transitionTo(state: State?) {
        guard let state = state else { return }
        self.state = state
    }
    
    func isStoredOperationPrimary() -> Bool {
        storedOperation == .multiply || storedOperation == .division
    }
    
    func replaceText(with text: String) {
        delegate?.replaceText(with: text)
    }
    
    func appendText(_ text: String) {
        delegate?.appendText(text)
    }
    
    func updateCalculationText(with number: Decimal? = nil) {
        delegate?.updateCalculationText(with: number ?? currentResult)
    }
    
    /// Calculate stored operation and then last stored secondary operation.
    /// If second number is nil, operation will be performed with stored number
    func calculateMultipleOperations(secondNumber: Decimal?) -> Decimal {
        let tempNumber = storedOperation.performOperation(
            num1: storedNumber,
            num2: secondNumber ?? storedNumber)
        return performOperation(ofType: lastSecondaryOperation,
                                secondNumber: tempNumber)
    }
    
    /// Calculate stored operation.
    /// If second number is nil, operation will be performed with stored number
    func calculateStoredOperation(secondNumber: Decimal?,
                                  withStoredNumber isStoredNumber: Bool = false) -> Decimal {
        return performOperation(ofType: storedOperation,
                                firstNumber: isStoredNumber ? storedNumber : nil,
                                secondNumber: secondNumber)
    }
    
    /// Calculate last stored secondary operation.
    /// If second number is nil, operation will be performed with stored number
    func calculateSecondaryOperation(secondNumber: Decimal?) -> Decimal {
        return performOperation(ofType: lastSecondaryOperation,
                                secondNumber: secondNumber)
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
    
    // MARK: Private methods
    private func performOperation(ofType type: OperationType,
                                  firstNumber: Decimal? = nil,
                                  secondNumber: Decimal? = nil) -> Decimal {
        return type.performOperation(num1: firstNumber ?? currentResult,
                                     num2: secondNumber ?? storedNumber)
    }
}
