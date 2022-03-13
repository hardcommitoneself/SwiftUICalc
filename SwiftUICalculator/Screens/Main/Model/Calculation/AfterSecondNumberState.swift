import Foundation

class AfterSecondNumberState: State {
    
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
        if calculator.isStoredOperationPrimary() {
            let result = calculator.calculateStoredOperation(secondNumber: number)
            calculator.storeCalculationInfo(
                result: result,
                numberToStore: result,
                operationToStore: type)
            calculator.updateCalculationText()
            return AfterFirstOperationState()
            
//            guard let result = context?.currentResult,
//                  let operation = context?.storedOperation else {
//                return
//            }
//
//            context?.currentResult = operation.performOperation(
//                num1: result,
//                num2: number ?? 0)
//            context?.storedNumber = context?.currentResult ?? 0
//            context?.storedOperation = type
//            context?.updateCalculationText()
        } else {
            calculator.storeCalculationInfo(numberToStore: number,
                                            operationToStore: type)
            return AfterPrimaryOperationState()
//            context?.storedNumber = number ?? 0
//            context?.storedOperation = type
        }
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: number)
        calculator.storeCalculationInfo(
            result: result,
            numberToStore: result,
            operationToStore: type,
            secondaryOperation: type)
        calculator.updateCalculationText()
        
//        guard let result = context?.currentResult,
//              let operation = context?.storedOperation else {
//            return
//        }
//
//        context?.currentResult = operation.performOperation(
//            num1: result,
//            num2: number ?? 0)
//        context?.storedNumber = context?.currentResult ?? 0
//        context?.lastSecondaryOperation = type
//        context?.storedOperation = type
//        context?.updateCalculationText()
        return AfterFirstOperationState()
    }
    
    func handleEqualOperation(calculator: Calculator, number: Decimal? = nil) -> State? {
        let result = calculator.calculateStoredOperation(secondNumber: number)
        calculator.storeCalculationInfo(result: result,
                                       numberToStore: number)
        calculator.updateCalculationText(with: nil)
        
//        guard let result = context?.currentResult,
//              let operation = context?.storedOperation else {
//            return
//        }
//        
//        context?.currentResult = operation.performOperation(
//            num1: result,
//            num2: number ?? 0)
//        context?.storedNumber = number ?? 0
//        context?.updateCalculationText()
        return AfterFirstOperationState()
    }
}
