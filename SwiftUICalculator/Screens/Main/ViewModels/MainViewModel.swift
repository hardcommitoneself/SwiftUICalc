import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published private(set) var calculationText: String
    
    @Published private var itemViewModels: [[ButtonViewModel]] = [[]]
    
    var columnCount: Int {
        4
    }
    
    var rowsCount: Int {
        itemViewModels.count
    }
    
    init() {
        calculationText = "0"
        itemViewModels = [
            [
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(
                        OperationType.UnaryOperationType.allClear.rawValue),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(
                        OperationType.UnaryOperationType.toggleSign.rawValue),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(
                        OperationType.UnaryOperationType.percent.rawValue),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .operation(OperationType.division.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("7"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("8"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("9"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .operation(OperationType.multiply.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("4"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("5"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("6"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .operation(OperationType.minus.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("1"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("2"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("3"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .operation(OperationType.plus.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("0"), size: 2)),
                ButtonViewModel(item: ItemInfo(keyType: .number(","), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .operation(OperationType.equal.rawValue),
                    size: 1))
            ]
        ]
    }
    
    func getItemsCount(atRow rowIndex: Int) -> Int {
        itemViewModels[rowIndex].count
    }
    
    func getItemViewModel(atRow rowIndex: Int, column: Int) -> ButtonViewModel {
        itemViewModels[rowIndex][column]
    }
}
