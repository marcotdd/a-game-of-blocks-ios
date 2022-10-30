import SwiftUI

enum BlockState {
    case empty
    case filled
    case underTheBridge
    case onMoving
}

struct Block {
    var state: BlockState = .empty
    var score: Int = 0
    
    var isTop: Bool
    var isSide: Bool
    var isBottom: Bool
    
    var isEmpty: Bool {
        switch state {
        case .empty:
            return true
            
        default:
            return false
        }
    }
    
    var isFilled: Bool {
        switch state {
        case .filled:
            return true
            
        default:
            return false
        }
    }
    
    var color: Color {
        switch state {
        case .empty, .underTheBridge:
            return .white
            
        case .filled:
            return .blockBlue
            
        case .onMoving:
            return .blockLightBlue
        }
    }
}
