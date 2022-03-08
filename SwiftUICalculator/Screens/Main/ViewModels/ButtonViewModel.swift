import SwiftUI

protocol ButtonViewModelDelegate: AnyObject {
    func didNumberTap(_ number: String)
    func didUnaryOperationTap(_ operation: OperationType)
    func didPrimaryOperationTap(_ operation: OperationType)
    func didSecondaryOperationTap(_ operation: OperationType)
    func didEqualTap()
}

class ButtonViewModel: ObservableObject {
    
    var delegate: ButtonViewModelDelegate?
    
    @Published var backgroundColor: Color
    @Published var foregroundColor: Color
    @Published private var item: ItemInfo
    
    private var operationType: OperationType {
        switch title {
        case OperationType.division.rawValue:
            return OperationType.division
        case OperationType.multiply.rawValue:
            return OperationType.multiply
        case OperationType.minus.rawValue:
            return OperationType.minus
        case OperationType.plus.rawValue:
            return OperationType.plus
        case OperationType.equal.rawValue:
            return OperationType.equal
        default:
            return OperationType.equal
        }
    }
    
    var title: String {
        item.keyType.title
    }
    
    init(item: ItemInfo) {
        self.item = item
        switch item.keyType {
        case .primaryOperation,
             .secondaryOperation:
            backgroundColor = Colors.darkBlue
            foregroundColor = Colors.white
        case .number,
             .unaryOperation:
            backgroundColor = Colors.lightGray
            foregroundColor = Colors.darkBlue
        }
    }
    
    func action() {
        switch item.keyType {
        case .number:
            delegate?.didNumberTap(item.keyType.title)
        case .unaryOperation:
            delegate?.didUnaryOperationTap(operationType)
        case .primaryOperation(OperationType.equal.rawValue):
            delegate?.didEqualTap()
        case .primaryOperation:
            colorizeOperationButton()
            delegate?.didPrimaryOperationTap(operationType)
        case .secondaryOperation:
            colorizeOperationButton()
            delegate?.didSecondaryOperationTap(operationType)
        }
    }
    
    // MARK: UI methods
    private func colorizeOperationButton() {
        backgroundColor = Colors.lightGray
        foregroundColor = Colors.darkBlue
    }
    
    private func resetOperationButtonColor() {
        backgroundColor = Colors.darkBlue
        foregroundColor = Colors.white
    }
    
    func getButtonWidth(width: CGFloat) -> CGFloat {
        let itemSize = CGFloat(item.size)
        return (width * itemSize) + (itemSize - 1) * 16
    }
    
    func getFontSize() -> CGFloat {
        switch item.keyType.title {
        case OperationType.division.rawValue,
             OperationType.minus.rawValue:
            return 44
        default:
            return 29
        }
    }
}
