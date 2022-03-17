import Foundation

enum CalculatorFormat {
    case portrait
    
    var items: [[ItemInfo]] {
        switch self {
        case .portrait:
            return CalculatorFormat.portraitItems
        }
    }
}

private extension CalculatorFormat {
    private static let portraitItems = [
        [
            ItemInfo(keyType: .unaryOperation(OperationType.allClear),
                     size: 1),
            ItemInfo(keyType: .unaryOperation(OperationType.toggleSign),
                     size: 1),
            ItemInfo(keyType: .unaryOperation(OperationType.percent),
                     size: 1),
            ItemInfo(keyType: .primaryOperation(OperationType.division),
                     size: 1)
        ],
        [
            ItemInfo(keyType: .number("7"), size: 1),
            ItemInfo(keyType: .number("8"), size: 1),
            ItemInfo(keyType: .number("9"), size: 1),
            ItemInfo(keyType: .primaryOperation(OperationType.multiply),
                     size: 1)
        ],
        [
            ItemInfo(keyType: .number("4"), size: 1),
            ItemInfo(keyType: .number("5"), size: 1),
            ItemInfo(keyType: .number("6"), size: 1),
            ItemInfo(keyType: .secondaryOperation(OperationType.minus),
                     size: 1)
        ],
        [
            ItemInfo(keyType: .number("1"), size: 1),
            ItemInfo(keyType: .number("2"), size: 1),
            ItemInfo(keyType: .number("3"), size: 1),
            ItemInfo(keyType: .secondaryOperation(OperationType.plus),
                     size: 1)
        ],
        [
            ItemInfo(keyType: .number("0"), size: 2),
            ItemInfo(keyType: .number(","), size: 1),
            ItemInfo(keyType: .primaryOperation(OperationType.equal),
                     size: 1)
        ]
    ]
}
