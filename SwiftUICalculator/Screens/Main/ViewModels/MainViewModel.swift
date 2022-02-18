import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published private var items: [[ItemInfo]] = [[]]
    
    var columnCount: Int {
        4
    }
    
    var rowsCount: Int {
        items.count
    }
    
    init() {
        items = [
            [
                ItemInfo(
                    keyType: .unaryOperation(OperationType.UnaryOperationType.allClear.rawValue),
                    size: 1),
                ItemInfo(
                    keyType: .unaryOperation(
                        OperationType.UnaryOperationType.toggleSign.rawValue),
                    size: 1),
                ItemInfo(
                    keyType: .unaryOperation(OperationType.UnaryOperationType.percent.rawValue),
                    size: 1),
                ItemInfo(keyType: .operation(OperationType.division.rawValue), size: 1)
            ],
            [
                ItemInfo(keyType: .number("7"), size: 1),
                ItemInfo(keyType: .number("8"), size: 1),
                ItemInfo(keyType: .number("9"), size: 1),
                ItemInfo(keyType: .operation(OperationType.multiply.rawValue), size: 1)
            ],
            [
                ItemInfo(keyType: .number("4"), size: 1),
                ItemInfo(keyType: .number("5"), size: 1),
                ItemInfo(keyType: .number("6"), size: 1),
                ItemInfo(keyType: .operation(OperationType.minus.rawValue), size: 1)
            ],
            [
                ItemInfo(keyType: .number("1"), size: 1),
                ItemInfo(keyType: .number("2"), size: 1),
                ItemInfo(keyType: .number("3"), size: 1),
                ItemInfo(keyType: .operation(OperationType.plus.rawValue), size: 1)
            ],
            [
                ItemInfo(keyType: .number("0"), size: 2),
                ItemInfo(keyType: .number(","), size: 1),
                ItemInfo(keyType: .operation(OperationType.equal.rawValue), size: 1)
            ]
        ]
        
        if case KeyType.operation("") = items[3][3].keyType {
            print("YEYAA")
        }
    }
    
    func getItemsCount(atRow rowIndex: Int) -> Int {
        items[rowIndex].count
    }
    
    func getItem(atRow rowIndex: Int, column: Int) -> ItemInfo {
        items[rowIndex][column]
    }
    
    func getItemBackground(keyType: KeyType) -> Color {
        switch keyType {
        case .number,
             .unaryOperation:
            return Colors.lightGray
        case .operation:
            return Colors.darkBlue
        }
    }
    
    func getItemForeground(keyType: KeyType) -> Color {
        switch keyType {
        case .number,
             .unaryOperation:
            return Colors.darkBlue
        case .operation:
            return Colors.white
        }
    }
}
