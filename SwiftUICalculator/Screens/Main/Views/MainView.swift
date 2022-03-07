import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            Colors.lightGray.ignoresSafeArea()
            VStack(alignment: .leading,
                   spacing: 25) {
                Text("Calculator")
                    .font(.museo())
                ZStack {
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
                            .opacity(0.08)
                        Text(viewModel.calculationText)
                    }
                    .font(.digital(size: 40))
                }
                .frame(height: 100)
                
                GeometryReader { geometryReader in
                    let columnWidth = viewModel.getColumnWidth(geometryReader.size.width)
                    
                    VStack(spacing: 16) {
                        ForEach(0..<viewModel.rowsCount) { row in
                            HStack(spacing: 16) {
                                ForEach(0..<viewModel.getItemsCount(atRow: row)) { column in
                                    let itemViewModel = viewModel
                                        .getItemViewModel(atRow: row, column: column)
                                    
                                    ButtonView(viewModel: itemViewModel,
                                               columnWidth: columnWidth)
                                }
                            }
                        }
                    }
                }
            }
            .padding(EdgeInsets(
                top: 25,
                leading: 24,
                bottom: 64,
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
