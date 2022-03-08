import Foundation

class AfterPrimaryBlockNumberState: BaseState {
    
    override func handleNumber(withValue number: String) {
        context?.appendText(number)
    }
    
    override func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        
    }
    
    override func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        guard let storedNumber = context?.storedNumber,
              let operation = context?.storedOperation else {
            return
        }
        
        context?.storedNumber = operation.performOperation(
            num1: storedNumber,
            num2: number ?? 0)
        context?.storedOperation = type
        context?.updateCalculationText(with: context?.storedNumber)
        context?.transitionTo(state: AfterPrimaryOperationState())
    }
    
    override func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        guard let result = context?.currentResult,
              let storedNumber = context?.storedNumber,
              let operation = context?.storedOperation,
              let secondaryOperation = context?.lastSecondaryOperation else {
            return
        }
        
        let tempResult = operation.performOperation(
            num1: storedNumber,
            num2: number ?? 0)
        context?.currentResult = secondaryOperation.performOperation(
            num1: result,
            num2: tempResult)
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
              let secondaryOperation = context?.lastSecondaryOperation else {
            return
        }
        
        let tempResult = operation.performOperation(
            num1: storedNumber,
            num2: number ?? 0)
        context?.currentResult = secondaryOperation.performOperation(
            num1: result,
            num2: tempResult)
        context?.storedNumber = number ?? 0
        context?.updateCalculationText()
        context?.transitionTo(state: AfterFirstOperationState())
    }
}
