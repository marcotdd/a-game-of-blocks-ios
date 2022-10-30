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
                        
                        Spacer()
                        
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
                }
                .navigationTitle("A Game Of Blocks")
                .padding(.horizontal, 16)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AGameOfBlocksBoardView()
    }
}
