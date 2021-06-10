//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import VirtualCoinKit

public class MarketViewModel: Identifiable, ObservableObject {
    public let id: String
    public let baseSymbol: String
    public let quoteSymbol: String
    public let priceUsd: Double
    public let price: Double
    
    init(market: Market, rateUsd: Double) {
        self.id = market.exchangeId
        self.baseSymbol = market.baseSymbol ?? ""
        self.quoteSymbol = market.quoteSymbol ?? ""
        
        if let priceUsd = market.priceUsd, let price = Double(priceUsd) {
            self.priceUsd = price
            self.price = price / rateUsd
        } else {
            self.priceUsd = 0
            self.price = 0
        }
    }
    
    init(id: String, baseSymbol: String?, quoteSymbol: String?, priceUsd: Double, price: Double) {
        self.id = id
        self.baseSymbol = baseSymbol ?? ""
        self.quoteSymbol = quoteSymbol ?? ""
        self.priceUsd = priceUsd
        self.price = price
    }
}
