import Foundation

enum KeyType {
    case number(String)
    case primaryOperation(String)
    case secondaryOperation(String)
    case unaryOperation(String)
    
    var title: String {
        switch self {
        case .number(let key),
             .primaryOperation(let key),
             .secondaryOperation(let key),
             .unaryOperation(let key):
            return key
        }
    }
}
