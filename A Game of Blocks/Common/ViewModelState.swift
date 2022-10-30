import Foundation

enum ViewModelState {
    case idle
    case loading
    case finished
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
            
        default:
            return false
        }
    }
    
    var isFinished: Bool {
        switch self {
        case .finished:
            return true
            
        default:
            return false
        }
    }
}
