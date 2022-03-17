import Foundation

class AfterFirstOperationState: State {
    
    func handleDigit(calculator: Calculator, withValue digit: String) -> State? {
        calculator.replaceText(with: digit)
        return AfterSecondNumberState()
    }
    
    func handleToggleSign(calculator: Calculator,
                          number: Decimal?) -> State? {
        calculator.storeCalculationInfo(result: number)
        calculator.replaceText(with: "-0")
        return AfterSecondNumberState()
    }
    
    func handlePercent(calculator: Calculator,
                       number: Decimal?) -> State? {
        guard let number = number else { return nil }
        let percent = calculator.isStoredOperationPrimary()
            ? number / 100
            : calculator.calculatePercent(from: number)
        
        calculator.storeCalculationInfo(numberToStore: percent)
        calculator.replaceText(with: percent)
        return nil
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
        calculator.replaceText()
        
        return nil
    }
}
