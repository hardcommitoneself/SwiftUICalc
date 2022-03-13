import Foundation

class BeforeCalculationState: State {
    
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
        calculator.storeCalculationInfo(result: number,
                                       numberToStore: number,
                                       operationToStore: type)
//        context?.currentResult = number ?? 0
//        context?.storedNumber = number ?? 0
//        context?.storedOperation = type
        return AfterFirstOperationState()
    }
    
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? {
        calculator.storeCalculationInfo(result: number,
                                       numberToStore: number,
                                       operationToStore: type,
                                       secondaryOperation: type)
//        context?.currentResult = number ?? 0
//        context?.storedNumber = number ?? 0
//        context?.lastSecondaryOperation = type
//        context?.storedOperation = type
        return AfterFirstOperationState()
    }
}
