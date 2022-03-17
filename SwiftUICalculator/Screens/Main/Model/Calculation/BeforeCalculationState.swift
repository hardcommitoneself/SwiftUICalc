import Foundation

class BeforeCalculationState: State {
    
    func handleDigit(_ calculator: Calculator,
                     withValue digit: String) -> State? {
        calculator.appendText(digit)
        return nil
    }
    
    func handleToggleSign(_ calculator: Calculator,
                          ofNumber number: Decimal?) -> State? {
        calculator.toggleTextSign()
        return nil
    }
    
    func handlePercent(_ calculator: Calculator,
                       ofNumber number: Decimal?) -> State? {
        guard let number = number else { return nil }
        calculator.replaceText(with: number / 100)
        return nil
    }
    
    func handlePrimaryOperation(_ calculator: Calculator,
                                ofType type: OperationType,
                                withNumber number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(result: number,
                                        numberToStore: number,
                                        operationToStore: type)
        return AfterFirstOperationState()
    }
    
    func handleSecondaryOperation(_ calculator: Calculator,
                                  ofType type: OperationType,
                                  withNumber number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(result: number,
                                        numberToStore: number,
                                        operationToStore: type,
                                        secondaryOperation: type)
        return AfterFirstOperationState()
    }
}
