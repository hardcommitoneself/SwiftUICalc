import SwiftUI

protocol ButtonViewModelDelegate: AnyObject {
    func didTapDigit(_ digit: String)
    func didTapUnaryOperation(_ operation: OperationType)
    func didTapPrimaryOperation(_ operation: OperationType)
    func didTapSecondaryOperation(_ operation: OperationType)
    func didTapEqual()
}

class ButtonViewModel: ObservableObject {
    
    @Published var backgroundColor: Color
    @Published var foregroundColor: Color
    @Published var title: String
    
    weak var delegate: ButtonViewModelDelegate?
    
    private var item: ItemInfo
    
    private var operationType: OperationType {
        item.keyType.operationType ?? OperationType.equal
    }
    
    init(item: ItemInfo) {
        self.item = item
        title = item.keyType.title
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
            delegate?.didTapDigit(item.keyType.title)
        case .unaryOperation:
            delegate?.didTapUnaryOperation(operationType)
        case .primaryOperation(OperationType.equal):
            delegate?.didTapEqual()
        case .primaryOperation:
            delegate?.didTapPrimaryOperation(operationType)
            colorizeOperationButton()
        case .secondaryOperation:
            delegate?.didTapSecondaryOperation(operationType)
            colorizeOperationButton()
        }
    }
    
    // MARK: UI methods
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
    
    func resetOperationButtonColor() {
        backgroundColor = Colors.darkBlue
        foregroundColor = Colors.white
    }
    
    private func colorizeOperationButton() {
        backgroundColor = Colors.lightGray
        foregroundColor = Colors.darkBlue
    }
}
