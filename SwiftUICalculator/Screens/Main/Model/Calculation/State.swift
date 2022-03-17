import Foundation

protocol State {
    func handleDigit(_ calculator: Calculator,
                     withValue digit: String) -> State?
    func handleToggleSign(_ calculator: Calculator,
                          ofNumber number: Decimal?) -> State?
    func handlePercent(_ calculator: Calculator,
                       ofNumber number: Decimal?) -> State?
    func handlePrimaryOperation(_ calculator: Calculator,
                                ofType type: OperationType,
                                withNumber number: Decimal?) -> State?
    func handleSecondaryOperation(_ calculator: Calculator,
                                  ofType type: OperationType,
                                  withNumber number: Decimal?) -> State?
    func handleEqualOperation(_ calculator: Calculator,
                              withNumber number: Decimal?) -> State?
}

extension State {
    func handleDigit(_ calculator: Calculator,
                     withValue digit: String) -> State? { return nil }
    
    func handleToggleSign(_ calculator: Calculator,
                          ofNumber number: Decimal?) -> State? { return nil }
    
    func handlePercent(_ calculator: Calculator,
                       ofNumber number: Decimal?) -> State? { return nil }
    
    func handlePrimaryOperation(
        _ calculator: Calculator,
        ofType type: OperationType,
        withNumber number: Decimal? = nil) -> State? { return nil }
    
    func handleSecondaryOperation(
        _ calculator: Calculator,
        ofType type: OperationType,
        withNumber number: Decimal? = nil) -> State? { return nil }
    
    func handleEqualOperation(
        _ calculator: Calculator,
        withNumber number: Decimal? = nil) -> State? { return nil }
}
