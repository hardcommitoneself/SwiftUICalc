import Foundation

class AfterFirstOperationState: State {
    
    func handleDigit(_ calculator: Calculator,
                     withValue digit: String) -> State? {
        calculator.replaceText(with: digit)
        return AfterSecondNumberState()
    }
    
    func handleToggleSign(_ calculator: Calculator,
                          ofNumber number: Decimal?) -> State? {
        calculator.storeCalculationInfo(result: number)
        calculator.replaceText(with: "-0")
        return AfterSecondNumberState()
    }
    
    func handlePercent(_ calculator: Calculator,
                       ofNumber number: Decimal?) -> State? {
        guard let number = number else { return nil }
        let percent = calculator.isStoredOperationPrimary()
            ? number / 100
            : calculator.calculatePercent(from: number)
        
        calculator.storeCalculationInfo(numberToStore: percent)
        calculator.replaceText(with: percent)
        return nil
    }
    
    func handlePrimaryOperation(_ calculator: Calculator,
                                ofType type: OperationType,
                                withNumber number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(operationToStore: type)
        return nil
    }
    
    func handleSecondaryOperation(_ calculator: Calculator,
                                  ofType type: OperationType,
                                  withNumber number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(operationToStore: type,
                                        secondaryOperation: type)
        return nil
    }
    
    func handleEqualOperation(_ calculator: Calculator,
                              withNumber number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: nil)
        calculator.storeCalculationInfo(result: result)
        calculator.replaceText()
        return nil
    }
}
