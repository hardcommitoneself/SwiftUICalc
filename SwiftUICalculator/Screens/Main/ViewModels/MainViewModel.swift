import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published private(set) var calculationText: String
    
    private var calculator: Calculator
    private var itemViewModels: [[ButtonViewModel]] = [[]]
    private var numberFromCalculationText: Decimal? {
        Decimal(string: calculationText.replacingOccurrences(of: ",", with: "."))
    }
    private var operationViewModels: [ButtonViewModel] {
        itemViewModels.compactMap { $0.last }
    }
    
    var columnCount: Int {
        4
    }
    
    var rowsCount: Int {
        itemViewModels.count
    }
    
    init() {
        calculator = Calculator()
        calculationText = "0"
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
    
    // MARK: Public methods
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
    
    // MARK: Private methods
    private func setupDelegates() {
        calculationText = calculator.calculationText
        itemViewModels.forEach { row in
            row.forEach { $0.delegate = self }
        }
    }
    
    private func resetOperationButtonsColors() {
        operationViewModels.forEach { viewModel in
            viewModel.resetOperationButtonColor()
        }
    }
}

// MARK: ButtonViewModelDelegate
extension MainViewModel: ButtonViewModelDelegate {
    func didTapDigit(_ digit: String) {
        calculator.handleDigit(withValue: digit)
        resetOperationButtonsColors()
        calculationText = calculator.calculationText
    }
    
    func didTapUnaryOperation(_ operation: OperationType) {
        
    }
    
    func didTapPrimaryOperation(_ operation: OperationType) {
        calculator.handlePrimaryOperation(ofType: operation,
                                          number: numberFromCalculationText)
        resetOperationButtonsColors()
        calculationText = calculator.calculationText
    }
    
    func didTapSecondaryOperation(_ operation: OperationType) {
        calculator.handleSecondaryOperation(ofType: operation,
                                            number: numberFromCalculationText)
        resetOperationButtonsColors()
        calculationText = calculator.calculationText
    }
    
    func didTapEqual() {
        calculator.handleEqualOperation(number: numberFromCalculationText)
        resetOperationButtonsColors()
        calculationText = calculator.calculationText
    }
}
