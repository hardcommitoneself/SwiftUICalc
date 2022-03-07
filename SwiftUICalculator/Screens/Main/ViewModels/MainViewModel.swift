import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published private(set) var calculationText: String
    
    @Published private var itemViewModels: [[ButtonViewModel]] = [[]]
    
    private var currentResult: Decimal
    private var lastSecondaryOperation: OperationType
    private var storedNumber: Decimal
    private var storedOperation: OperationType
    
    private var state: State
    
    var columnCount: Int {
        4
    }
    
    var rowsCount: Int {
        itemViewModels.count
    }
    
    init() {
        state = .beginning
        calculationText = "0"
        currentResult = 0
        storedNumber = 0
        lastSecondaryOperation = .plus
        storedOperation = .plus
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
        for row in itemViewModels {
            for viewModel in row {
                viewModel.delegate = self
            }
        }
    }
    
    // MARK: Support methods
    private func replaceCurrentText(with text: String) {
        if text == "," {
            calculationText = "0" + text
        } else {
            calculationText = text
        }
    }
    
    private func appendText(_ text: String) {
        if calculationText == "0" {
            replaceCurrentText(with: text)
        } else {
            if (text != "," || !calculationText.contains(","))
                && calculationText.count < 9 {
                calculationText += text
            }
        }
    }
}

extension MainViewModel: ButtonViewModelDelegate {
    func didNumberTap(_ number: String) {
        switch state {
        case .beginning,
             .afterSecondNumber,
             .afterSecondNumberInPrimaryBlock:
            appendText(number)
        case .afterFirstOperation:
            replaceCurrentText(with: number)
            state = .afterSecondNumber
        case .afterSecondPrimaryOperation:
            replaceCurrentText(with: number)
            state = .afterSecondNumberInPrimaryBlock
        }
    }
    
    func didUnaryOperationTap(_ operation: OperationType) {
        
    }
    
    func didPrimaryOperationTap(_ operation: OperationType) {
        switch state {
        case .beginning:
            currentResult = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: ".")) ?? 0
            storedNumber = currentResult
            storedOperation = operation
            state = .afterFirstOperation
        case .afterFirstOperation:
            storedOperation = operation
        case .afterSecondNumber:
            switch storedOperation {
            case .division,
                 .multiply:
                storedNumber = Decimal(string: calculationText
                                        .replacingOccurrences(of: ",", with: ".")) ?? 0
                currentResult = storedOperation.performOperation(
                    num1: currentResult,
                    num2: storedNumber)
                calculationText = String(describing: currentResult)
                storedNumber = currentResult
                storedOperation = operation
                state = .afterFirstOperation
            case .minus,
                 .plus:
                storedNumber = Decimal(string: calculationText
                                        .replacingOccurrences(of: ",", with: ".")) ?? 0
                storedOperation = operation
                state = .afterSecondPrimaryOperation
            default:
                return
            }
        case .afterSecondPrimaryOperation:
            storedOperation = operation
        case .afterSecondNumberInPrimaryBlock:
            let tempNumber = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: ".")) ?? 0
            currentResult = storedOperation.performOperation(
                num1: storedNumber,
                num2: tempNumber)
            calculationText = String(describing: currentResult)
            storedNumber = currentResult
            storedOperation = operation
            state = .afterSecondPrimaryOperation
        }
    }
    
    func didSecondaryOperationTap(_ operation: OperationType) {
        switch state {
        case .beginning:
            currentResult = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: ".")) ?? 0
            storedNumber = currentResult
            lastSecondaryOperation = operation
            storedOperation = operation
            state = .afterFirstOperation
        case .afterFirstOperation:
            lastSecondaryOperation = operation
            storedOperation = operation
        case .afterSecondNumber:
            storedNumber = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: ".")) ?? 0
            currentResult = storedOperation.performOperation(
                num1: currentResult,
                num2: storedNumber)
            calculationText = String(describing: currentResult)
            storedNumber = currentResult
            lastSecondaryOperation = operation
            storedOperation = operation
            state = .afterFirstOperation
        case .afterSecondPrimaryOperation:
            currentResult = lastSecondaryOperation.performOperation(
                num1: currentResult,
                num2: storedNumber)
            calculationText = String(describing: currentResult)
            storedNumber = currentResult
            lastSecondaryOperation = operation
            storedOperation = operation
            state = .afterFirstOperation
        case .afterSecondNumberInPrimaryBlock:
            let tempNum = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: ".")) ?? 0
            let result = storedOperation.performOperation(
                num1: storedNumber,
                num2: tempNum)
            currentResult = lastSecondaryOperation.performOperation(
                num1: currentResult,
                num2: result)
            calculationText = String(describing: currentResult)
            storedNumber = currentResult
            lastSecondaryOperation = operation
            storedOperation = operation
            state = .afterFirstOperation
        }
    }
    
    func didEqualTap() {
        switch state {
        case .beginning:
            return
        case .afterFirstOperation:
            currentResult = storedOperation.performOperation(
                num1: currentResult,
                num2: storedNumber)
            calculationText = String(describing: currentResult)
        case .afterSecondNumber:
            storedNumber = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: ".")) ?? 0
            currentResult = storedOperation.performOperation(
                num1: currentResult,
                num2: storedNumber)
            calculationText = String(describing: currentResult)
            state = .afterFirstOperation
        case .afterSecondPrimaryOperation:
            let tempNumber = storedOperation.performOperation(
                num1: storedNumber,
                num2: storedNumber)
            currentResult = lastSecondaryOperation.performOperation(
                num1: currentResult,
                num2: tempNumber)
            calculationText = String(describing: currentResult)
            state = .afterFirstOperation
        case .afterSecondNumberInPrimaryBlock:
            let tempNum = Decimal(string: calculationText
                                    .replacingOccurrences(of: ",", with: ".")) ?? 0
            let result = storedOperation.performOperation(
                num1: storedNumber,
                num2: tempNum)
            currentResult = lastSecondaryOperation.performOperation(
                num1: currentResult,
                num2: result)
            calculationText = String(describing: currentResult)
            storedNumber = tempNum
            state = .afterFirstOperation
        }
    }
}
