import SwiftUI

enum BlockState {
    case empty
    case filled
}

struct Block {
    var state: BlockState = .empty
    var score: Int = 0
    var isSide: Bool
    
    var isEmpty: Bool {
        switch state {
        case .empty:
            return true
            
        case .filled:
            return false
        }
    }
    
    var color: Color {
        switch state {
        case .empty:
            return .white
            
        case .filled:
            return .blockBlue
        }
    }
}
