import SwiftUI

class ButtonViewModel: ObservableObject {
    
    @Published private var item: ItemInfo
    
    var title: String {
        item.keyType.title
    }
    
    init(item: ItemInfo) {
        self.item = item
    }
    
    func getButtonWidth(width: CGFloat) -> CGFloat {
        let itemSize = CGFloat(item.size)
        return (width * itemSize) + (itemSize - 1) * 16
    }
    
    func getItemBackground() -> Color {
        switch item.keyType {
        case .number,
             .unaryOperation:
            return Colors.lightGray
        case .operation:
            return Colors.darkBlue
        }
    }
    
    func getItemForeground() -> Color {
        switch item.keyType {
        case .number,
             .unaryOperation:
            return Colors.darkBlue
        case .operation:
            return Colors.white
        }
    }
    
    func getFontSize() -> CGFloat {
        switch item.keyType {
        case .operation(OperationType.division.rawValue),
             .operation(OperationType.minus.rawValue):
            return 44
        default:
            return 29
        }
    }
}
