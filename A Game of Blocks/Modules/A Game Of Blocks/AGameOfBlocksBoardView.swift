import SwiftUI

struct AGameOfBlocksBoardView: View {
    @StateObject private var viewModel: AGameOfBlocksBoardViewModel = AGameOfBlocksBoardViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.lightGray, Color.white]),
                    startPoint: .bottomLeading,
                    endPoint: .topLeading
                ).ignoresSafeArea()
                
                GeometryReader { geometryReader in
                    VStack {
                        playGrid(blockSize: geometryReader.size.width / CGFloat(viewModel.columnsCount))
                        
                        if viewModel.state.isFinished {
                            Text("Score: \(viewModel.totalScore)")
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        restartButton
                    }
                }
                .navigationTitle("A Game Of Blocks")
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var restartButton: some View {
        Button {
            viewModel.restart()
        } label: {
            Text("Restart")
                .fontWeight(.bold)
                .padding(.horizontal, 80)
                .padding(.vertical, 16)
                .background(Color.lightBlue)
                .foregroundColor(.white)
                .clipShape(Rectangle())
            
        }
        .padding(.bottom, 32)
    }
    
    private func playGrid(blockSize: CGFloat) -> some View {
        LazyVGrid(
            columns: [GridItem](repeating: GridItem(.flexible(), spacing: 0), count: viewModel.columnsCount),
            spacing: 0
        ) {
            ForEach(Array(zip(viewModel.blocks.indices, viewModel.blocks)), id: \.0) { index, block in
                Rectangle()
                    .frame(width: blockSize, height: blockSize)
                    .border(Color.lightGray, width: 1)
                    .foregroundColor(block.color)
                    .overlay(
                        Text("\(block.score)")
                            .opacity(block.score > 0 && viewModel.state.isFinished ? 1.0 : 0)
                            .foregroundColor(block.isFilled ? .white : .black)
                    )
                    .onTapGesture {
                        if !viewModel.state.isLoading {
                            viewModel.onBlockSelected(index)
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
