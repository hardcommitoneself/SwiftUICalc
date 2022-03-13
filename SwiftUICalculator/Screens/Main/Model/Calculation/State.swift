import Foundation

protocol State {
    func handleDigit(calculator: Calculator, withValue digit: String) -> State?
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal?) -> State?
    func handlePrimaryOperation(calculator: Calculator,
                                ofType type: OperationType,
                                number: Decimal?) -> State?
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal?) -> State?
    func handleEqualOperation(calculator: Calculator,
                              number: Decimal?) -> State?
}

extension State {
    func handleDigit(calculator: Calculator, withValue digit: String) -> State? { return nil }
    func handleUnaryOperation(calculator: Calculator,
                              ofType type: OperationType,
                              number: Decimal? = nil) -> State? { return nil }
    func handlePrimaryOperation(calculator: Calculator,
                                ofType type: OperationType,
                                number: Decimal? = nil) -> State? { return nil }
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? { return nil }
    func handleEqualOperation(calculator: Calculator,
                              number: Decimal? = nil) -> State? { return nil }
}
