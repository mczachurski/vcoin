//
//  Date.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import Foundation

extension Date {
    var unixTimestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1_000)
    }
}
