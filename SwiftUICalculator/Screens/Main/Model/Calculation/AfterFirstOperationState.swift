import Foundation

class AfterFirstOperationState: BaseState {
    
    override func handleNumber(withValue number: String) {
        context?.replaceCurrentText(with: number)
        context?.transitionTo(state: AfterSecondNumberState())
    }
    
    override func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {}
    
    override func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        context?.storedOperation = type
    }
    
    override func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        context?.lastSecondaryOperation = type
        context?.storedOperation = type
    }
    
    override func handleEqualOperation(number: Decimal? = nil) {
        guard let result = context?.currentResult,
              let storedNumber = context?.storedNumber,
              let operation = context?.storedOperation else {
            return
        }
        context?.currentResult = operation.performOperation(
            num1: result,
            num2: storedNumber)
        context?.updateCalculationText()
    }
}
