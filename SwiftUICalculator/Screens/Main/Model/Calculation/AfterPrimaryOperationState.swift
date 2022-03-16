import Foundation

class AfterPrimaryOperationState: State {
    
    func handleDigit(calculator: Calculator, withValue digit: String) -> State? {
        calculator.replaceText(with: digit)
        return AfterPrimaryBlockNumberState()
    }
    
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal? = nil) -> State? {
        switch type {
        case .toggleSign:
            calculator.storeCalculationInfo(numberToStore: number)
            calculator.replaceText(with: "-0")
            return AfterPrimaryBlockNumberState()
        case .percent:
            return nil
        default:
            return nil
        }
    }
    
    func handlePrimaryOperation(calculator: Calculator,
                                ofType type: OperationType,
                                number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(operationToStore: type)
        return nil
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        let result = calculator.calculateSecondaryOperation(secondNumber: nil)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: result,
                                        operationToStore: type,
                                        secondaryOperation: type)
        calculator.updateCalculationText()
        
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(secondNumber: number)
        calculator.storeCalculationInfo(result: result)
        calculator.updateCalculationText()
        
        return AfterFirstOperationState()
    }
}
