import SwiftUI

final class MainViewModel: ObservableObject {
    
    // MARK: Published fields
    @Published private(set) var calculationText: String
    
    // MARK: Private fields
    private var calculator: Calculator
    private var calculationString: CalculationString
    private var itemViewModels: [[ButtonViewModel]] = [[]]
    
    // MARK: Properties
    var columnCount: Int {
        4
    }
    
    var rowsCount: Int {
        itemViewModels.count
    }
    
    private var numberFromCalculationText: Decimal? {
        Decimal(string: calculationText.replacingOccurrences(of: ",", with: "."))
    }
    
    private var operationViewModels: [ButtonViewModel] {
        itemViewModels.compactMap { $0.last }
    }
    
    // MARK: Initialization
    init() {
        calculator = Calculator()
        calculationString = CalculationString("0")
        calculationText = "0"
        itemViewModels = [
            [
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(OperationType.allClear),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(OperationType.toggleSign),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .unaryOperation(OperationType.percent),
                    size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .primaryOperation(OperationType.division),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("7"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("8"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("9"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .primaryOperation(OperationType.multiply),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("4"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("5"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("6"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .secondaryOperation(OperationType.minus),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("1"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("2"), size: 1)),
                ButtonViewModel(item: ItemInfo(keyType: .number("3"), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .secondaryOperation(OperationType.plus),
                    size: 1))
            ],
            [
                ButtonViewModel(item: ItemInfo(keyType: .number("0"), size: 2)),
                ButtonViewModel(item: ItemInfo(keyType: .number(","), size: 1)),
                ButtonViewModel(item: ItemInfo(
                    keyType: .primaryOperation(OperationType.equal),
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
        calculator.delegate = self
        itemViewModels.forEach { row in
            row.forEach { $0.delegate = self }
        }
    }
}

// MARK: ButtonViewModelDelegate
extension MainViewModel: ButtonViewModelDelegate {
    func didTapDigit(_ digit: String) {
        calculator.handleDigit(withValue: digit)
    }
    
    func didTapUnaryOperation(_ operation: OperationType) {
        calculator.handleUnaryOperation(ofType: operation,
                                        number: numberFromCalculationText)
    }
    
    func didTapPrimaryOperation(_ operation: OperationType) {
        calculator.handlePrimaryOperation(ofType: operation,
                                          number: numberFromCalculationText)
    }
    
    func didTapSecondaryOperation(_ operation: OperationType) {
        calculator.handleSecondaryOperation(ofType: operation,
                                            number: numberFromCalculationText)
    }
    
    func didTapEqual() {
        calculator.handleEqualOperation(number: numberFromCalculationText)
    }
}

// MARK: CalculatorDelegate
extension MainViewModel: CalculatorDelegate {
    func calculator(didAppendTextWithValue text: String) {
        calculationText = calculationString.validatedAppend(text: text)
    }
    
    func calculator(didReplaceTextWith text: String) {
        calculationText = calculationString.validatedReplace(with: text)
    }
    
    func calculator(didReplaceTextWith number: Decimal) {
        calculationText = calculationString.validatedReplace(with: number)
    }
    
    func calculatorDidToggleTextSign() {
        calculationText = calculationString.toggleTextSign()
    }
    
    func calculatorDidResetUI() {
        operationViewModels.forEach { viewModel in
            viewModel.resetOperationButtonColor()
        }
    }
}
