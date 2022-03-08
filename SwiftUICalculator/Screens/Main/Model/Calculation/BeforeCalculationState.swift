import Foundation

class BeforeCalculationState: BaseState {
    
    override func handleNumber(withValue number: String) {
        context?.appendText(number)
    }
    
    override func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {}
    
    override func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        context?.currentResult = number ?? 0
        context?.storedNumber = number ?? 0
        context?.storedOperation = type
        context?.transitionTo(state: AfterFirstOperationState())
    }
    
    override func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {
        context?.currentResult = number ?? 0
        context?.storedNumber = number ?? 0
        context?.lastSecondaryOperation = type
        context?.storedOperation = type
        context?.transitionTo(state: AfterFirstOperationState())
    }
}
