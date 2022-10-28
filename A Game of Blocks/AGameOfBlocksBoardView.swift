import SwiftUI

struct AGameOfBlocksBoardView: View {
    @StateObject private var viewModel: AGameOfBlocksBoardViewModel = AGameOfBlocksBoardViewModel()
    
    var body: some View {
        GeometryReader { geometryReader in
            VStack {
                Text("A Game Of Blocks")
                    .font(.title)
                LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible(), spacing: 0), count: viewModel.columns), spacing: 0) {
                    ForEach(Array(zip(viewModel.board.indices, viewModel.board)), id: \.0) { index, block in
                        let blockSize = geometryReader.size.width / CGFloat(viewModel.columns)
                        Rectangle()
                            .frame(width: blockSize, height: blockSize)
                            .border(Color.lightGray, width: 1)
                            .foregroundColor(block.color)
                            .overlay(Text("\(index)"))
                            .onTapGesture {
                                if !viewModel.state.isLoading {
                                    viewModel.onBlockSelected(index)
                                }
                            }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AGameOfBlocksBoardView()
    }
}
