//
//  Float.swift
//  vcoin
//
//  Created by Marcin Czachurski on 12.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

extension Double {
    func toFormattedPrice() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency

        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "en-US")

        let priceString = currencyFormatter.string(from: NSNumber(value: self))
        return priceString ?? ""
    }
    
    var absoluteValue: Double {
        if self > 0.0 {
            return self
        }
        else {
            return -1 * self
        }
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

