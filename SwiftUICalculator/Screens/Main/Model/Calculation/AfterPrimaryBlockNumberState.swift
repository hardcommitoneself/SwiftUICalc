import Foundation

class AfterPrimaryBlockNumberState: State {
    
    func handleNumber(calculator: Calculator, withValue number: String) -> State? {
        calculator.appendText(number)
        return nil
    }
    
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal? = nil) -> State? {
        return nil
    }
    
    func handlePrimaryOperation(calculator: Calculator,
                                ofType type: OperationType,
                                number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: number)
        calculator.storeCalculationInfo(numberToStore: result,
                                        operationToStore: type)
        calculator.updateCalculationText(with: result)
        
//        guard let storedNumber = context?.storedNumber,
//              let operation = context?.storedOperation else {
//            return
//        }
//
//        context?.storedNumber = operation.performOperation(
//            num1: storedNumber,
//            num2: number ?? 0)
//        context?.storedOperation = type
//        context?.updateCalculationText(with: context?.storedNumber)
        return AfterPrimaryOperationState()
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(secondNumber: number)
        calculator.storeCalculationInfo(
            result: result,
            numberToStore: result,
            operationToStore: type,
            secondaryOperation: type)
        calculator.updateCalculationText()
        
//        guard let result = context?.currentResult,
//              let storedNumber = context?.storedNumber,
//              let operation = context?.storedOperation,
//              let secondaryOperation = context?.lastSecondaryOperation else {
//            return
//        }
//
//        let tempResult = operation.performOperation(
//            num1: storedNumber,
//            num2: number ?? 0)
//        context?.currentResult = secondaryOperation.performOperation(
//            num1: result,
//            num2: tempResult)
//        context?.storedNumber = context?.currentResult ?? 0
//        context?.lastSecondaryOperation = type
//        context?.storedOperation = type
//        context?.updateCalculationText()
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateMultipleOperations(secondNumber: number)
        calculator.storeCalculationInfo(result: result,
                                        numberToStore: number)
        calculator.updateCalculationText()
        
//        guard let result = context?.currentResult,
//              let storedNumber = context?.storedNumber,
//              let operation = context?.storedOperation,
//              let secondaryOperation = context?.lastSecondaryOperation else {
//            return
//        }
//
//        let tempResult = operation.performOperation(
//            num1: storedNumber,
//            num2: number ?? 0)
//        context?.currentResult = secondaryOperation.performOperation(
//            num1: result,
//            num2: tempResult)
//        context?.storedNumber = number ?? 0
//        context?.updateCalculationText()
        return AfterFirstOperationState()
    }
}
