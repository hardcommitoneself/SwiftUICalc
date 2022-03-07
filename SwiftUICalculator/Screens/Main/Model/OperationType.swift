import Foundation

enum OperationType: String {
    case division = "÷"
    case multiply = "X"
    case minus = "-"
    case plus = "+"
    case equal = "="
    
    case allClear = "AC"
    case toggleSign = "+/-"
    case percent = "%"
    
    func performOperation(num1: Decimal, num2: Decimal) -> Decimal {
        switch self {
        case .division:
            return num1 / num2
        case .multiply:
            return num1 * num2
        case .minus:
            return num1 - num2
        case .plus:
            return num1 + num2
        default:
            return 0
        }
    }
}
