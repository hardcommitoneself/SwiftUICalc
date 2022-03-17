import Foundation

class AfterPrimaryBlockNumberState: State {
    
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
        let result = calculator.calculateStoredOperation(secondNumber: number,
                                                         withStoredNumber: true)
        calculator.storeCalculationInfo(numberToStore: result,
                                        operationToStore: type)
        calculator.replaceText(with: result)
        
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
        calculator.replaceText()
        
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(secondNumber: number)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: number)
        calculator.replaceText()
        
        return AfterFirstOperationState()
    }
}
