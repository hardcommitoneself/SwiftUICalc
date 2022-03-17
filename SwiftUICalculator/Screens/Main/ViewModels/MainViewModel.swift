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
    init(format: CalculatorFormat = .portrait) {
        calculator = Calculator()
        calculationString = CalculationString(Strings.calculationPlaceholder)
        calculationText = Strings.calculationPlaceholder
        itemViewModels = format.items.map { row in
            row.map { item in
                let viewModel = ButtonViewModel(item: item)
                viewModel.delegate = self
                return viewModel
            }
        }
        calculator.delegate = self
    }
    
    // MARK: Public methods
    func getItemsCount(atRow rowIndex: Int) -> Int {
        itemViewModels[rowIndex].count
    }
    
    func getItemViewModel(atRow rowIndex: Int, column: Int) -> ButtonViewModel {
        itemViewModels[rowIndex][column]
    }
    
    func getColumnWidth(_ containerWidth: CGFloat) -> CGFloat {
        let padWidth = containerWidth
                        - CGFloat(columnCount - 1)
                        * Dimensions.defaultSpacing
        return padWidth / CGFloat(columnCount)
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
