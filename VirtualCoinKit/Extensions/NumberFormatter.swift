//
//  NumberFormatter.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 05/06/2021.
//

import Foundation

public extension NumberFormatter {
    static var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
                
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
    
        return formatter
    }()
}
