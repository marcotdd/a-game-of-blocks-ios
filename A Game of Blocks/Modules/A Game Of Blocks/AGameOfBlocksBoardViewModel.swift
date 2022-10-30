import Foundation
import SwiftUI

class AGameOfBlocksBoardViewModel: ObservableObject {
    @Published var board: [Block] = []
    @Published var state: ViewModelState = .idle
    
    let boardSize: Int = 25
    let columns: Int = 5

    var score: Int = 0
    
    private let numberOfMoves: Int = 10

    private var timer: Timer?
    private var selectedBlockIndex: Int?
    
    init() {
        setup()
    }
    
    func onBlockSelected(_ index: Int) {
        guard board.filter({ !$0.isEmpty }).count < numberOfMoves else {
            state = .finished
            return
        }
        guard board[index].isEmpty else { return }
        board[index].state = .filled
        selectedBlockIndex = index
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: moveBlock)
    }
    
    func restart() {
        timer?.invalidate()
        state = .idle
        setup()
    }
    
    private func setup() {
        board = []
        for index in 0..<boardSize {
            let isSideBlock = index % columns == 0 || (index + 1) % columns == 0
            board.append(Block(isSide: isSideBlock))
        }
    }
    
    private func moveBlock(timer: Timer) {
        guard let index = selectedBlockIndex else { return }
        guard !state.isFinished else { return }
        
        state = .loading
        
        let nextIndex = index + columns
        if index < boardSize - columns && board[nextIndex].isEmpty && !isInBetween(selectedBlockIndex: index) {
            board[index].state = .empty
            board[nextIndex].state = .filled
            selectedBlockIndex = nextIndex
        } else {
            timer.invalidate()
            
            if board.filter({ !$0.isEmpty }).count < numberOfMoves {
                state = .idle
            } else {
                state = .finished
            }
        }
    }
    
    private func isInBetween(selectedBlockIndex: Int) -> Bool {
        let block = board[selectedBlockIndex]
        
        if block.isSide {
            return false
        }
            
        return !board[selectedBlockIndex-1].isEmpty && !board[selectedBlockIndex+1].isEmpty
    }
}
