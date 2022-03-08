import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published private(set) var calculationText: String
    
    @Published private var itemViewModels: [[ButtonViewModel]] = [[]]
    
//    private var currentResult: Decimal
//    private var lastSecondaryOperation: OperationType
//    private var storedNumber: Decimal
//    private var storedOperation: OperationType
    
//    private var state: Staate
    private let calculator: Calculator
    
    var columnCount: Int {
        4
    }
    
    var rowsCount: Int {
        itemViewModels.count
    }
    
    init() {
        calculator = Calculator(BeforeCalculationState())
//        state = .beginning
        calculationText = "0"
//        currentResult = 0
//        storedNumber = 0
//        lastSecondaryOperation = .plus
//        storedOperation = .plus
        itemViewModels = [
            [
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(OperationType.allClear.rawValue),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(OperationType.toggleSign.rawValue),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(OperationType.percent.rawValue),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .primaryOperation(OperationType.division.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("7"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("8"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("9"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .primaryOperation(OperationType.multiply.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("4"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("5"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("6"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .secondaryOperation(OperationType.minus.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("1"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("2"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("3"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .secondaryOperation(OperationType.plus.rawValue),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("0"), size: 2)),
                ButtonViewModel(item: ItemInfo(keyType: .number(","), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .primaryOperation(OperationType.equal.rawValue),
                    size: 1))
            ]
        ]
        
        setupDelegates()
    }
    
    func getItemsCount(atRow rowIndex: Int) -> Int {
        itemViewModels[rowIndex].count
    }
    
    func getItemViewModel(atRow rowIndex: Int, column: Int) -> ButtonViewModel {
        itemViewModels[rowIndex][column]
    }
    
    func getColumnWidth(_ containerWidth: CGFloat) -> CGFloat {
        let padWidth = containerWidth - CGFloat(columnCount - 1) * 16
        return padWidth / CGFloat(columnCount)
    }
    
    private func setupDelegates() {
        itemViewModels.forEach { row in
            row.forEach { $0.delegate = self }
        }
    }
}

extension MainViewModel: ButtonViewModelDelegate {
    func didNumberTap(_ number: String) {
        calculator.handleDigit(withValue: number)
        calculationText = calculator.calculationText
    }
    
    func didUnaryOperationTap(_ operation: OperationType) {
        
    }
    
    func didPrimaryOperationTap(_ operation: OperationType) {
        let tempNumber = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: "."))
        calculator.handlePrimaryOperation(ofType: operation, number: tempNumber)
        calculationText = calculator.calculationText
    }
    
    func didSecondaryOperationTap(_ operation: OperationType) {
        let tempNumber = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: "."))
        calculator.handleSecondaryOperation(ofType: operation, number: tempNumber)
        calculationText = calculator.calculationText
    }
    
    func didEqualTap() {
        let tempNumber = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: "."))
        calculator.handleEqualOperation(number: tempNumber)
        calculationText = calculator.calculationText
    }
}
