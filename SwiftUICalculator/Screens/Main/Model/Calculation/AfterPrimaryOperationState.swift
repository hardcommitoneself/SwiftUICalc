import Foundation

class AfterPrimaryOperationState: BaseState {
    
    override func handleNumber(withValue number: String) {
        context?.replaceCurrentText(with: number)
        context?.transitionTo(state: AfterPrimaryBlockNumberState())
    }
    
    override func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {}
    
    override func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        context?.storedOperation = type
    }
    
    override func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        guard let result = context?.currentResult,
              let storedNumber = context?.storedNumber,
              let operation = context?.lastSecondaryOperation else {
            return
        }
        
        context?.currentResult = operation.performOperation(
            num1: result,
            num2: storedNumber)
        context?.storedNumber = context?.currentResult ?? 0
        context?.lastSecondaryOperation = type
        context?.storedOperation = type
        context?.updateCalculationText()
        context?.transitionTo(state: AfterFirstOperationState())
    }
    
    override func handleEqualOperation(number: Decimal? = nil) {
        guard let result = context?.currentResult,
              let storedNumber = context?.storedNumber,
              let operation = context?.storedOperation,
              let secondaryOperstion = context?.lastSecondaryOperation else {
            return
        }
        
        let tempNumber = operation.performOperation(
            num1: storedNumber,
            num2: number ?? 0)
        context?.currentResult = secondaryOperstion.performOperation(
            num1: result,
            num2: tempNumber)
        context?.updateCalculationText()
        context?.transitionTo(state: AfterFirstOperationState())
    }
}
