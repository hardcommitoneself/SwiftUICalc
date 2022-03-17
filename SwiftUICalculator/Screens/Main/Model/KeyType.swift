import Foundation

enum KeyType {
    case number(String)
    case primaryOperation(OperationType)
    case secondaryOperation(OperationType)
    case unaryOperation(OperationType)
    
    var title: String {
        switch self {
        case .number(let key):
            return key
        case .primaryOperation(let key),
             .secondaryOperation(let key),
             .unaryOperation(let key):
            return key.rawValue
        }
    }
    
    var operationType: OperationType? {
        switch self {
        case .primaryOperation(let key),
             .secondaryOperation(let key),
             .unaryOperation(let key):
            return key
        default:
            return nil
        }
    }
}
