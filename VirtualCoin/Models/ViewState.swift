//
//  ViewState.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 16/05/2021.
//

import Foundation

public enum ViewState<T> {
    case iddle
    case loading
    case loaded(T)
    case error(Error)
}
