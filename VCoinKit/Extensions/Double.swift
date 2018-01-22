//
//  Float.swift
//  vcoin
//
//  Created by Marcin Czachurski on 12.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

extension Double {
    public func toFormattedPrice(currency: String) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        
        var locale = "en-US"
        if let currency = CurrencyLocale.allCurrenciesDictionary[currency] {
            locale = currency.locale
        }

        currencyFormatter.locale = Locale(identifier: locale)
        let priceString = currencyFormatter.string(from: NSNumber(value: self))
        return priceString ?? ""
    }
    
    public func toFormattedPercent() -> String {
        return String(self.rounded(toPlaces: 2)) + " %"
    }
    
    public var absoluteValue: Double {
        if self > 0.0 {
            return self
        }
        else {
            return -1 * self
        }
    }
    
    public func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

