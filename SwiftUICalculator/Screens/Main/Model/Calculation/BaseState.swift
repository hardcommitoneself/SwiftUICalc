import Foundation

protocol State: AnyObject {
    func update(context: Calculator)
    
    func handleNumber(withValue number: String)
    func handleUnaryOperation(ofType type: OperationType, number: Decimal?)
    func handlePrimaryOperation(ofType type: OperationType, number: Decimal?)
    func handleSecondaryOperation(ofType type: OperationType, number: Decimal?)
    func handleEqualOperation(number: Decimal?)
}

class BaseState: State {
    
    private(set) weak var context: Calculator?
    
    func update(context: Calculator) {
        self.context = context
    }
    
    func handleNumber(withValue number: String) {}
    func handleUnaryOperation(ofType type: OperationType, number: Decimal? = nil) {}
    func handlePrimaryOperation(ofType type: OperationType, number: Decimal? = nil) {}
    func handleSecondaryOperation(ofType type: OperationType, number: Decimal? = nil) {}
    func handleEqualOperation(number: Decimal? = nil) {}
}
