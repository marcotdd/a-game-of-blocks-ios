import Foundation
import SwiftUI

final class AGameOfBlocksBoardViewModel: ObservableObject {
    
    // MARK: - Observables & Properties
    
    @Published var blocks: [Block] = []
    @Published var state: ViewModelState = .idle
    
    private let settings = Settings()
    
    private var isGameOver: Bool {
        blocks.filter({ $0.isFilled }).count >= settings.numberOfMoves
    }
    
    var boardSize: Int { get { settings.boardSize } }
    var columnsCount: Int { get { settings.columns } }
    var totalScore: Int = 0

    // MARK: - Initializer
    
    init() {
        setup()
    }
    
    // MARK: - Public funcs
    
    func onBlockSelected(_ index: Int) {
        guard !state.isFinished else { return }
        guard blocks[index].isEmpty else { return }
        
        state = .loading
        moveBlock(index: index)
        
    }
    
    func restart() {
        state = .idle
        setup()
    }
    
    // MARK: - Private funcs
    
    /// It firstly resets the list of Blocks
    /// and then creates a new array of block which represents the Play Grid
    private func setup() {
        blocks = []
        
        for index in 0..<boardSize {
            let block = Block(
                isTop: (0..<settings.columns).contains(index),
                isSide: index % settings.columns == 0 || (index + 1) % settings.columns == 0,
                indexBelow: index + settings.columns < boardSize ? index + settings.columns : nil
            )
            
            blocks.append(block)
        }
    }
    
    /// It is the engine of the game.
    /// This function rules the Block movements and it also handles the end of the game.
    private func moveBlock(index: Int, indexAbove: Int? = nil) {
        
        if let indexAbove = indexAbove {
            blocks[indexAbove].state = .empty
        }
                
        if let indexBelow = blocks[index].indexBelow, blocks[indexBelow].isEmpty, !isInBetween(index: index) {
            // The block moves down ⬇️
            
            blocks[index].state = .onMoving
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // This condition stops the execution in case the button Restart has been tapped
                if self.state.isLoading {
                    self.moveBlock(index: indexBelow, indexAbove: index)
                }
            }
        } else {
            // The block stops ✋
            
            blocks[index].state = .filled
            bridgeCheck(index: index)

            if isGameOver {
                state = .finished
                calculateTotalScore()
            } else {
                state = .idle
            }
        }
    }
    
    /// It returns true if the current index Block is between two Blocks.
    private func isInBetween(index: Int) -> Bool {
        if blocks[index].isSide {
            return false
        }
            
        return !blocks[index-1].isEmpty && !blocks[index+1].isEmpty
    }
    
    private func bridgeCheck(index: Int) {
        guard let indexBelow = blocks[index].indexBelow else { return }

        guard blocks[indexBelow].isEmpty else { return }
        
        blocks[indexBelow].state = .underTheBridge
        bridgeCheck(index: indexBelow)
    }
    
    private func calculateTotalScore() {
        for index in stride(from: settings.boardSize-1, to: 0, by: -1) {
            if blocks[index].isUnderTheBridge {
                blocks[index].score = settings.underTheBridgeScore
            } else if blocks[index].isFilled {
                if let indexBelow = blocks[index].indexBelow, blocks[indexBelow].isFilled {
                    blocks[index].score = blocks[indexBelow].score + settings.regularBlockScore
                } else {
                    blocks[index].score = settings.regularBlockScore
                }
            }
        }
        totalScore = blocks.map({ $0.score }).reduce(0, +)
    }
}
