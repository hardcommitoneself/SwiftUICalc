import Foundation

class BeforeCalculationState: State {
    
    func handleDigit(calculator: Calculator, withValue digit: String) -> State? {
        calculator.appendText(digit)
        return nil
    }
    
    func handleToggleSign(calculator: Calculator,
                          number: Decimal?) -> State? {
        calculator.toggleTextSign()
        return nil
    }
    
    func handlePercent(calculator: Calculator,
                       number: Decimal?) -> State? {
        guard let number = number else { return nil }
        calculator.replaceText(with: number / 100)
        return nil
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
