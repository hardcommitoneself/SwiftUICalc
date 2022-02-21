import SwiftUI

struct ButtonView: View {
    
    private let width: CGFloat
    private let action: () -> Void
    
    @ObservedObject private var viewModel: ButtonViewModel
    
    init(viewModel: ButtonViewModel,
         width: CGFloat,
         action: @escaping (() -> Void)) {
        self.viewModel = viewModel
        self.width = width
        self.action = action
    }
    
    var body: some View {
        Button(viewModel.title, action: self.action)
            .frame(width: viewModel.getButtonWidth(width: width), height: width)
            .foregroundColor(viewModel.getItemForeground())
            .background(viewModel.getItemBackground())
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
            width: 64) { }
    }
}
