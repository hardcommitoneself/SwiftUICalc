import Foundation

protocol State {
    func handleDigit(calculator: Calculator, withValue digit: String) -> State?
    func handleToggleSign(calculator: Calculator,
                          number: Decimal?) -> State?
    func handlePercent(calculator: Calculator,
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
    func handleDigit(calculator: Calculator,
                     withValue digit: String) -> State? { return nil }
    func handleToggleSign(calculator: Calculator,
                          number: Decimal?) -> State? { return nil }
    func handlePercent(calculator: Calculator,
                       number: Decimal?) -> State? { return nil }
    func handlePrimaryOperation(calculator: Calculator,
                                ofType type: OperationType,
                                number: Decimal? = nil) -> State? { return nil }
    func handleSecondaryOperation(calculator: Calculator,
                                  ofType type: OperationType,
                                  number: Decimal? = nil) -> State? { return nil }
    func handleEqualOperation(calculator: Calculator,
                              number: Decimal? = nil) -> State? { return nil }
}
