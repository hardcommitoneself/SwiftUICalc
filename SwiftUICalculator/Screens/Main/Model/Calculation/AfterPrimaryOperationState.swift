import Foundation

class AfterPrimaryOperationState: State {
    
    func handleNumber(calculator: Calculator, withValue number: String) -> State? {
        calculator.replaceText(with: number)
        return AfterPrimaryBlockNumberState()
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
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        let result = calculator.calculateSecondaryOperation(secondNumber: nil)
        calculator.storeCalculationInfo(
            result: result,
            numberToStore: result,
            operationToStore: type,
            secondaryOperation: type)
        calculator.updateCalculationText()
        
//        guard let result = context?.currentResult,
//              let storedNumber = context?.storedNumber,
//              let operation = context?.lastSecondaryOperation else {
//            return
//        }
//
//        context?.currentResult = operation.performOperation(
//            num1: result,
//            num2: storedNumber)
//        context?.storedNumber = context?.currentResult ?? 0
//        context?.lastSecondaryOperation = type
//        context?.storedOperation = type
//        context?.updateCalculationText()
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(secondNumber: number)
        calculator.storeCalculationInfo(result: result)
        calculator.updateCalculationText()
        
//        guard let result = context?.currentResult,
//              let storedNumber = context?.storedNumber,
//              let operation = context?.storedOperation,
//              let secondaryOperstion = context?.lastSecondaryOperation else {
//            return
//        }
//
//        let tempNumber = operation.performOperation(
//            num1: storedNumber,
//            num2: number ?? 0)
//        context?.currentResult = secondaryOperstion.performOperation(
//            num1: result,
//            num2: tempNumber)
//        context?.updateCalculationText()
        return AfterFirstOperationState()
    }
}
