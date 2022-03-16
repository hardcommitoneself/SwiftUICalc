import Foundation

class AfterPrimaryBlockNumberState: State {
    
    func handleDigit(calculator: Calculator, withValue digit: String) -> State? {
        calculator.appendText(digit)
        return nil
    }
    
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal? = nil) -> State? {
        switch type {
        case .toggleSign:
            calculator.toggleTextSign()
            return nil
        case .percent:
            return nil
        default:
            return nil
        }
    }
    
    func handlePrimaryOperation(calculator: Calculator,
                                ofType type: OperationType,
                                number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: number,
                                                         withStoredNumber: true)
        calculator.storeCalculationInfo(numberToStore: result,
                                        operationToStore: type)
        calculator.updateCalculationText(with: result)
        
        return AfterPrimaryOperationState()
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(secondNumber: number)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: result,
                                        operationToStore: type,
                                        secondaryOperation: type)
        calculator.updateCalculationText()
        
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(secondNumber: number)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: number)
        calculator.updateCalculationText()
        
        return AfterFirstOperationState()
    }
}
