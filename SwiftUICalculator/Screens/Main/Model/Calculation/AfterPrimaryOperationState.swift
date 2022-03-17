import Foundation

class AfterPrimaryOperationState: State {
    
    func handleDigit(_ calculator: Calculator,
                     withValue digit: String) -> State? {
        calculator.replaceText(with: digit)
        return AfterPrimaryBlockNumberState()
    }
    
    func handleToggleSign(_ calculator: Calculator,
                          ofNumber number: Decimal?) -> State? {
        calculator.storeCalculationInfo(numberToStore: number)
        calculator.replaceText(with: "-0")
        return AfterPrimaryBlockNumberState()
    }
    
    func handlePercent(_ calculator: Calculator,
                       ofNumber number: Decimal?) -> State? {
        guard let number = number else { return nil }
        let percent = number / 100
        
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
        let result = calculator.calculateSecondaryOperation(secondNumber: nil)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: result,
                                        operationToStore: type,
                                        secondaryOperation: type)
        calculator.replaceText()
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(_ calculator: Calculator,
                              withNumber number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(
            secondNumber: number)
        calculator.storeCalculationInfo(result: result)
        calculator.replaceText()
        
        return AfterFirstOperationState()
    }
}
