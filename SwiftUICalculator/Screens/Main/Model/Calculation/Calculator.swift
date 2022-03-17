import Foundation

protocol CalculatorDelegate: AnyObject {
    func calculator(didAppendTextWithValue text: String)
    func calculator(didReplaceTextWith text: String)
    func calculator(didReplaceTextWith number: Decimal)
    func calculatorDidToggleTextSign()
    func calculatorDidResetUI()
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
    
    // MARK: Input handling methods
    func handleDigit(withValue digit: String) {
        transitionTo(state: state.handleDigit(calculator: self,
                                              withValue: digit))
        delegate?.calculatorDidResetUI()
    }
    
    func handleUnaryOperation(ofType type: OperationType,
                              number: Decimal? = nil) {
        switch type {
        case .allClear:
            resetCalculator()
            transitionTo(state: BeforeCalculationState())
        case .toggleSign:
            transitionTo(state: state.handleToggleSign(calculator: self,
                                                       number: number))
        case .percent:
            transitionTo(state: state.handlePercent(calculator: self,
                                                    number: number))
        default: ()
        }
    }
    
    func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        transitionTo(state: state.handlePrimaryOperation(calculator: self,
                                                         ofType: type,
                                                         number: number))
        delegate?.calculatorDidResetUI()
    }
    
    func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        transitionTo(state: state.handleSecondaryOperation(calculator: self,
                                                           ofType: type,
                                                           number: number))
        delegate?.calculatorDidResetUI()
    }
    
    func handleEqualOperation(number: Decimal? = nil) {
        transitionTo(state: state.handleEqualOperation(calculator: self, number: number))
        delegate?.calculatorDidResetUI()
    }
    
    // MARK: Delegate wrapper methods
    func replaceText(with text: String) {
        delegate?.calculator(didReplaceTextWith: text)
    }
    
    func replaceText(with number: Decimal? = nil) {
        delegate?.calculator(didReplaceTextWith: number ?? currentResult)
    }
    
    func appendText(_ text: String) {
        delegate?.calculator(didAppendTextWithValue: text)
    }
    
    func toggleTextSign() {
        delegate?.calculatorDidToggleTextSign()
    }
    
    // MARK: Public service methods
    func transitionTo(state: State?) {
        guard let state = state else { return }
        self.state = state
    }
    
    func isStoredOperationPrimary() -> Bool {
        storedOperation == .multiply || storedOperation == .division
    }
    
    func calculatePercent(from number: Decimal) -> Decimal {
        currentResult * number / 100
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
    func storeCalculationInfo(
        result: Decimal? = nil,
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
    
    private func resetCalculator() {
        currentResult = 0
        storedNumber = 0
        delegate?.calculatorDidResetUI()
        delegate?.calculator(didReplaceTextWith: 0)
    }
}
