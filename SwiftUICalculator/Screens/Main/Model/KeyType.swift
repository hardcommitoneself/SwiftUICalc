import Foundation

enum KeyType {
    case number(String)
    case operation(String)
    case unaryOperation(String)
    
    var title: String {
        switch self {
        case .number(let key),
             .operation(let key),
             .unaryOperation(let key):
            return key
        }
    }
}
