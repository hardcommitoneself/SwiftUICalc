import Foundation

class AfterFirstOperationState: State {
    
    func handleNumber(calculator: Calculator, withValue number: String) -> State? {
        calculator.replaceText(with: number)
        return AfterSecondNumberState()
    }
    
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal? = nil) -> State? {
        return nil
    }
    
    func handlePrimaryOperation(calculator: Calculator,
                                ofType type: OperationType,
                                number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(operationToStore: type)
        return nil
//        context?.storedOperation = type
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(operationToStore: type,
                                       secondaryOperation: type)
        return nil
//        context?.lastSecondaryOperation = type
//        context?.storedOperation = type
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: nil)
        calculator.storeCalculationInfo(result: result)
        calculator.updateCalculationText()
        return nil
        
//        guard let result = context?.currentResult,
//              let storedNumber = context?.storedNumber,
//              let operation = context?.storedOperation else {
//            return
//        }
//
//        context?.currentResult = operation.performOperation(
//            num1: result,
//            num2: storedNumber)
//        context?.updateCalculationText()
    }
}
