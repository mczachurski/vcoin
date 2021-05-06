//
//  MarketViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 05/05/2021.
//

import Foundation
import VirtualCoinKit

public class MarketViewModel: Identifiable, ObservableObject {
    public let id: String
    public let baseSymbol: String
    public let quoteSymbol: String
    public let priceUsd: Double
    
    init(market: Market) {
        self.id = market.exchangeId
        self.baseSymbol = market.baseSymbol ?? ""
        self.quoteSymbol = market.quoteSymbol ?? ""
        
        if let priceUsd = market.priceUsd, let price = Double(priceUsd) {
            self.priceUsd = price
        } else {
            self.priceUsd = 0
        }
    }
    
    init(id: String, baseSymbol: String?, quoteSymbol: String?, priceUsd: Double) {
        self.id = id
        self.baseSymbol = baseSymbol ?? ""
        self.quoteSymbol = quoteSymbol ?? ""
        self.priceUsd = priceUsd
    }
}
