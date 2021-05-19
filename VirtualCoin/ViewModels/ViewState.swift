//
//  ViewState.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 16/05/2021.
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
