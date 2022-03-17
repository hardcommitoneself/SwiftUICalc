import SwiftUI

private extension Dimensions {
    static let shadowOffset: CGFloat = 5
    static let shadowBlur: CGFloat = 5
}

struct ButtonView: View {
    
    private let columnWidth: CGFloat
    
    @ObservedObject private var viewModel: ButtonViewModel
    
    init(viewModel: ButtonViewModel,
         columnWidth: CGFloat) {
        self.viewModel = viewModel
        self.columnWidth = columnWidth
    }
    
    var body: some View {
        Button {
            viewModel.action()
        } label: {
            Text(viewModel.title)
                .frame(width: viewModel.getButtonWidth(width: columnWidth), height: columnWidth)
                .foregroundColor(viewModel.foregroundColor)
                .background(viewModel.backgroundColor)
                .cornerRadius(Dimensions.mediumCornerRadius)
                .font(.montserrat(size: viewModel.getFontSize()))
                .shadow(color: Colors.shadowBlue,
                        radius: Dimensions.shadowBlur,
                        x: Dimensions.shadowOffset,
                        y: Dimensions.shadowOffset)
                .shadow(color: .white,
                        radius: Dimensions.shadowBlur,
                        x: -Dimensions.shadowOffset,
                        y: -Dimensions.shadowOffset)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(
            viewModel: ButtonViewModel(item: ItemInfo(keyType: .number("0"), size: 1)),
            columnWidth: 64)
    }
}
