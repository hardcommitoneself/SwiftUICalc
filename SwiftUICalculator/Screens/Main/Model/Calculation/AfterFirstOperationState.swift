import Foundation

class AfterFirstOperationState: State {
    
    func handleDigit(calculator: Calculator, withValue digit: String) -> State? {
        calculator.replaceText(with: digit)
        return AfterSecondNumberState()
    }
    
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal? = nil) -> State? {
        switch type {
        case .toggleSign:
            calculator.storeCalculationInfo(result: number)
            calculator.replaceText(with: "-0")
            return AfterSecondNumberState()
        case .percent:
            return nil
        default:
            return nil
        }
//        guard let number = number else { return nil }
//        switch type {
//        case .toggleSign:
//            calculator.storeCalculationInfo(numberToStore: 0)
//            calculator.replaceText(with: "-0")
//            return AfterSecondNumberState()
//        case .percent:
//            let percentResult = calculator.calculatePercent(from: number)
//            calculator.storeCalculationInfo(numberToStore: percentResult)
//            calculator.updateCalculationText(with: percentResult)
//            return AfterSecondNumberState()
//        default:
//            return nil
//        }
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
        calculator.storeCalculationInfo(operationToStore: type,
                                        secondaryOperation: type)
        return nil
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: nil)
        calculator.storeCalculationInfo(result: result)
        calculator.updateCalculationText()
        
        return nil
    }
}
