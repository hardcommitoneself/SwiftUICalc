import SwiftUI

private extension Dimensions {
    static let calculatorPaddings = EdgeInsets(
        top: Dimensions.mediumPadding,
        leading: Dimensions.mediumPadding,
        bottom: Dimensions.largePadding,
        trailing: Dimensions.mediumPadding)
    
    static let backgroundTextOpacity: CGFloat = 0.08
    static let calculationFontSize: CGFloat = 40
    static let calculationFrameHeight: CGFloat = 100
}

struct MainView: View {
    
    @ObservedObject private var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            Color.lightGray.ignoresSafeArea()
            VStack(alignment: .leading,
                   spacing: Dimensions.mediumSpacing) {
                Text(Strings.calculatorTitle)
                    .font(.museo())
                ZStack {
                    LinearGradient(
                        colors: [
                            .lightGreen,
                            .darkGreen
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .cornerRadius(Dimensions.smallCornerRadius)
                    
                    ZStack(alignment: .leading) {
                        Text(Strings.calculationBackgroundText)
                            .opacity(Dimensions.backgroundTextOpacity)
                        Text(viewModel.calculationText)
                    }
                    .font(.digital(size: Dimensions.calculationFontSize))
                }
                .frame(height: Dimensions.calculationFrameHeight)
                
                GeometryReader { geometryReader in
                    let cellSize = viewModel.getCellSize(
                        inContainerOfSize: geometryReader.size)
                    
                    VStack(spacing: Dimensions.defaultSpacing) {
                        ForEach(0..<viewModel.rowsCount, id:\.self) { row in
                            HStack(spacing: Dimensions.defaultSpacing) {
                                ForEach(0..<viewModel.getItemsCount(atRow: row),
                                        id:\.self) { column in
                                    let itemViewModel = viewModel
                                        .getItemViewModel(atRow: row,
                                                          column: column)
                                    
                                    ButtonView(viewModel: itemViewModel,
                                               cellSize: cellSize)
                                }
                            }
                        }
                    }
                }
            }.padding(Dimensions.calculatorPaddings)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
