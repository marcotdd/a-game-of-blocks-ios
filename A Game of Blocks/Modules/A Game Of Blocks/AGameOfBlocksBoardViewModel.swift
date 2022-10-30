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
        guard !state.isFinished else { return }
        guard board[index].isEmpty else { return }
        board[index].state = .onMoving
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
            let isATopBlock = (0..<columns).contains(index)
            let isASideBlock = index % columns == 0 || (index + 1) % columns == 0
            let isABottomBlock = ((boardSize - columns)..<boardSize).contains(index)
            board.append(Block(isTop: isATopBlock, isSide: isASideBlock, isBottom: isABottomBlock))
        }
    }
    
    private func moveBlock(timer: Timer) {
        guard let index = selectedBlockIndex else { return }
        
        state = .loading
        
        let nextIndex = index + columns
        if index < boardSize - columns && board[nextIndex].isEmpty && !isInBetween(selectedBlockIndex: index) {
            board[index].state = .empty
            board[nextIndex].state = .onMoving
            selectedBlockIndex = nextIndex
        } else {
            timer.invalidate()
            board[index].state = .filled
            assignScore(for: index)

            if board.filter({ $0.isFilled }).count < numberOfMoves {
                state = .idle
            } else {
                state = .finished
                score = board.map({ $0.score }).reduce(0, +)
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
    
    private func assignScore(for index: Int) {
        if board[index].isBottom {
            board[index].score = 5
        } else if board[index + columns].isEmpty {
            board[index].score = 5
        } else {
            board[index].score = 5 + board[index + columns].score
        }
        assignScoreOnBlankBlocksBelow(index: index)
    }
    
    private func assignScoreOnBlankBlocksBelow(index: Int) {
        guard !board[index].isBottom else { return }
        let nextIndex = index + columns
        guard board[nextIndex].isEmpty else { return }
        
        board[nextIndex].score = 10
        board[nextIndex].state = .underTheBridge
        assignScoreOnBlankBlocksBelow(index: nextIndex)
    }
}
