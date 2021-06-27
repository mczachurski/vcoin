//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public enum ViewState: Equatable {
    case iddle
    case loading
    case loaded
    case error(Error)
    
    static public func ==(lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.loaded, .loaded):
            return true
        case (.loading,.loading):
            return true
        case (.iddle,.iddle):
            return true
        default:
            return false
        }
    }
}
