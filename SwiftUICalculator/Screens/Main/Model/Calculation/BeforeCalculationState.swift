import Foundation

class BeforeCalculationState: State {
    
    func handleDigit(calculator: Calculator, withValue digit: String) -> State? {
        calculator.appendText(digit)
        return nil
    }
    
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal? = nil) -> State? {
        guard let number = number else { return nil }

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
        calculator.storeCalculationInfo(result: number,
                                        numberToStore: number,
                                        operationToStore: type)
        return AfterFirstOperationState()
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(result: number,
                                        numberToStore: number,
                                        operationToStore: type,
                                        secondaryOperation: type)
        return AfterFirstOperationState()
    }
}
