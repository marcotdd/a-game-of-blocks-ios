import Foundation

enum ViewModelState {
    case loading
    case idle
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
            
        case .idle:
            return false
        }
    }
}
