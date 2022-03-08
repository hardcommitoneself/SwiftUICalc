import Foundation

class AfterSecondNumberState: BaseState {
    
    override func handleNumber(withValue number: String) {
        context?.appendText(number)
    }
    
    override func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {}
    
    override func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        switch context?.storedOperation {
        case .division,
             .multiply:
            guard let result = context?.currentResult,
                  let operation = context?.storedOperation else {
                return
            }
            
            context?.currentResult = operation.performOperation(
                num1: result,
                num2: number ?? 0)
            context?.storedNumber = context?.currentResult ?? 0
            context?.storedOperation = type
            context?.updateCalculationText()
            context?.transitionTo(state: AfterFirstOperationState())
        case .minus,
             .plus:
            context?.storedNumber = number ?? 0
            context?.storedOperation = type
            context?.transitionTo(state: AfterPrimaryOperationState())
        default:
            return
        }
    }
    
    override func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        guard let result = context?.currentResult,
              let operation = context?.storedOperation else {
            return
        }
        
        context?.currentResult = operation.performOperation(
            num1: result,
            num2: number ?? 0)
        context?.storedNumber = context?.currentResult ?? 0
        context?.lastSecondaryOperation = type
        context?.storedOperation = type
        context?.updateCalculationText()
        context?.transitionTo(state: AfterFirstOperationState())
    }
    
    override func handleEqualOperation(number: Decimal? = nil) {
        guard let result = context?.currentResult,
              let operation = context?.storedOperation else {
            return
        }
        
        context?.currentResult = operation.performOperation(
            num1: result,
            num2: number ?? 0)
        context?.storedNumber = number ?? 0
        context?.updateCalculationText()
        context?.transitionTo(state: AfterFirstOperationState())
    }
}
