import Foundation

enum OperationType: String {
    case division = "÷"
    case multiply = "X"
    case minus = "-"
    case plus = "+"
    case equal = "="
    
    enum UnaryOperationType: String {
        case allClear = "AC"
        case toggleSign = "+/-"
        case percent = "%"
    }
}
