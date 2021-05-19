//
//  DispatchQueue.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 19/05/2021.
//

import Foundation

public extension DispatchQueue {
    static func runOnMain(_ handler: @escaping () -> Void) {
        if Thread.isMainThread {
            handler()
        } else {
            DispatchQueue.main.async(execute: handler)
        }
    }
}
