import Foundation

class AfterSecondNumberState: State {
    
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
        let percent = calculator.isStoredOperationPrimary()
            ? number / 100
            : calculator.calculatePercent(from: number)
        
        calculator.storeCalculationInfo(numberToStore: percent)
        calculator.replaceText(with: percent)
        return AfterFirstOperationState()
    }
    
    func handlePrimaryOperation(_ calculator: Calculator,
                                ofType type: OperationType,
                                withNumber number: Decimal? = nil) -> State? {
        if calculator.isStoredOperationPrimary() {
            let result = calculator.calculateStoredOperation(
                secondNumber: number)
            calculator.storeCalculationInfo(result: result,
                                            numberToStore: result,
                                            operationToStore: type)
            calculator.replaceText()
            return AfterFirstOperationState()
        }
        
        calculator.storeCalculationInfo(numberToStore: number,
                                        operationToStore: type)
        return AfterPrimaryOperationState()
    }
    
    func handleSecondaryOperation(_ calculator: Calculator,
                                  ofType type: OperationType,
                                  withNumber number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: number)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: result,
                                        operationToStore: type,
                                        secondaryOperation: type)
        calculator.replaceText()
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(_ calculator: Calculator,
                              withNumber number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: number)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: number)
        calculator.replaceText()
        
        return AfterFirstOperationState()
    }
}
