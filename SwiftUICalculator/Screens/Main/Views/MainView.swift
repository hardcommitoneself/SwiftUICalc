import SwiftUI

struct MainView: View {
    @State private var inputText: String = "2345"
    
    @ObservedObject private var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            Colors.lightGray.ignoresSafeArea()
            VStack(alignment: .leading,
                   spacing: 25) {
                Text("Calculator")
                    .font(.museo())
                ZStack() {
                    LinearGradient(
                        colors: [
                            Colors.lightGreen,
                            Colors.darkGreen
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                        .cornerRadius(10)
                    
                    ZStack(alignment: .leading) {
                        Text("8888888888")
                            .font(.digital(size: 40))
                            .opacity(0.08)
                        Text(inputText)
                            .font(.digital(size: 40))
                    }
                }
                .frame(height: 100)
                Spacer()
                GeometryReader { geometryReader in
                    let padWidth = geometryReader.size.width
                    - (CGFloat(viewModel.columnCount - 1) * 16)
                    let width = padWidth / CGFloat(viewModel.columnCount)

                    VStack(spacing: 16) {
                        ForEach(0..<viewModel.rowsCount) { row in
                            HStack(spacing: 16) {
                                ForEach(0..<viewModel.getItemsCount(atRow: row)) { column in
                                    let item = viewModel.getItem(atRow: row, column: column)
                                    let itemSize = CGFloat(item.size)
                                    let buttonWidth = (width * itemSize) + (itemSize - 1) * 16

                                    Button(item.keyType.title) {

                                    }
                                    .frame(width: buttonWidth, height: width)
                                    .foregroundColor(
                                        viewModel.getItemForeground(keyType: item.keyType))
                                    .background(
                                        viewModel.getItemBackground(keyType: item.keyType))
                                    .cornerRadius(20)
                                    .font(.montserrat())
                                    .shadow(color: Colors.shadowBlue, radius: 10, x: 5, y: 5)
                                    .shadow(color: .white, radius: 10, x: -5, y: -5)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(EdgeInsets(
                top: 25,
                leading: 24,
                bottom: 0,
                trailing: 24)
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
