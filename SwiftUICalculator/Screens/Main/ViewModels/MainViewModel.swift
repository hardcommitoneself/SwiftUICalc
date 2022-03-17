import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published private(set) var calculationText: String
    
    private var calculator: Calculator
    private var itemViewModels: [[ButtonViewModel]] = [[]]
    
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
    
    init() {
        calculator = Calculator()
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
    func calculator(didReplaceTextWith text: String) {
        if text == "," {
            calculationText = "0" + text
        } else {
            calculationText = text
        }
    }
    
    func calculator(didAppendTextWithValue text: String) {
        if calculationText == "0" {
            calculator(didReplaceTextWith: text)
        } else if calculationText == "-0" {
            calculator(didReplaceTextWith: text)
            calculationText.insert("-", at: calculationText.startIndex)
        } else {
            if (text != "," || !calculationText.contains(","))
                && calculationText.count < 9 {
                calculationText += text
            }
        }
    }
    
    func calculatorDidToggleTextSign() {
        if calculationText.first == "-" {
            calculationText.removeFirst()
        } else {
            calculationText.insert("-", at: calculationText.startIndex)
        }
    }
    
    func calculator(didReplaceTextWith number: Decimal) {
        calculationText = String(describing: number)
            .replacingOccurrences(of: ".", with: ",")
    }
    
    func calculatorDidResetUI() {
        operationViewModels.forEach { viewModel in
            viewModel.resetOperationButtonColor()
        }
    }
}
