//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

public extension Double {
    func toFormattedAmount() -> String {
        return NumberFormatter.amountFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func toFormattedPrice(currency: String) -> String {
        return self.toFormattedPrice(currency: currency, maximumFractionDigits: 4)
    }

    func toFormattedPrice(currency: String, maximumFractionDigits: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        currencyFormatter.numberStyle = NumberFormatter.Style.currency

        var locale = "en-US"
        if let currency = Currencies.allCurrenciesDictionary[currency] {
            locale = currency.locale
        }

        currencyFormatter.locale = Locale(identifier: locale)
        let priceString = currencyFormatter.string(from: NSNumber(value: self))
        return priceString ?? ""
    }

    func toFormattedPercent() -> String {
        return String(self.rounded(toPlaces: 2)) + "%"
    }

    var absoluteValue: Double {
        if self > 0.0 {
            return self
        } else {
            return -1 * self
        }
    }

    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
