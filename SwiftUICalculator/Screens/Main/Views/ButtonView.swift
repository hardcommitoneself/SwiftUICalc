import SwiftUI

struct ButtonView: View {
    
    private let columnWidth: CGFloat
    
    @ObservedObject private var viewModel: ButtonViewModel
    
    init(viewModel: ButtonViewModel,
         columnWidth: CGFloat) {
        self.viewModel = viewModel
        self.columnWidth = columnWidth
    }
    
    var body: some View {
        Button(viewModel.title) {
            viewModel.action()
        }
        .frame(width: viewModel.getButtonWidth(width: columnWidth), height: columnWidth)
        .foregroundColor(viewModel.foregroundColor)
        .background(viewModel.backgroundColor)
        .cornerRadius(20)
        .font(.montserrat(size: viewModel.getFontSize()))
        .shadow(color: Colors.shadowBlue, radius: 5, x: 5, y: 5)
        .shadow(color: .white, radius: 5, x: -5, y: -5)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(
            viewModel: ButtonViewModel(item: ItemInfo(keyType: .number("0"), size: 1)),
            columnWidth: 64)
    }
}
