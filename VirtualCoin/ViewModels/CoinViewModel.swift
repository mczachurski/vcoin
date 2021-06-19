//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import VirtualCoinKit

public class CoinViewModel: Identifiable, ObservableObject {
    public let id: String
    public let rank: Int
    public let symbol: String
    public let name: String
    public let imageUrl: String
    public let orginalPriceUsd: Double

    @Published public var price: Double = 0.0
    @Published public var isFavourite = false
    @Published public var priceUsd: Double
    @Published public var changePercent24Hr: Double
    
    init(coin: Coin) {
        self.id = coin.id
        self.symbol = coin.symbol
        self.name = coin.name
        
        if let rank = Int(coin.rank) {
            self.rank = rank
        } else {
            self.rank = 0
        }
        
        var internalPriceUsd = 0.0
        if let priceUsd = coin.priceUsd, let price = Double(priceUsd) {
            internalPriceUsd = price
        }
        
        var internalChangePercent24Hr = 0.0
        if let changePercent24Hr = coin.changePercent24Hr, let price = Double(changePercent24Hr) {
            internalChangePercent24Hr = price
        }
        
        self.priceUsd = internalPriceUsd
        self.changePercent24Hr = internalChangePercent24Hr
        self.orginalPriceUsd = internalPriceUsd / ((internalChangePercent24Hr / 100) + 1)
        self.imageUrl = "https://static.coincap.io/assets/icons/\(symbol.lowercased())@2x.png"
    }
    
    init(id: String = "bitcoin", rank: Int = 1, symbol: String = "BTC", name: String = "Bitcoin", priceUsd: Double = 0.0, changePercent24Hr: Double = 0.0) {
        self.id = id
        self.rank = rank
        self.symbol = symbol
        self.name = name
        self.priceUsd = priceUsd
        self.orginalPriceUsd = priceUsd
        self.price = priceUsd
        self.changePercent24Hr = changePercent24Hr
        self.imageUrl = "https://static.coincap.io/assets/icons/\(symbol.lowercased())@2x.png"
    }
}

extension CoinViewModel {
    public func refresh(priceUsd: String?, changePercent24Hr: String?, withRateUsd rateUsd: Double) {
        if let priceUsd = priceUsd, let price = Double(priceUsd) {
            self.priceUsd = price
            self.price = price / rateUsd
        }
        
        if let changePercent24Hr = changePercent24Hr, let price = Double(changePercent24Hr) {
            self.changePercent24Hr = price
        }
    }
}

extension CoinViewModel: Hashable {
    public static func == (lhs: CoinViewModel, rhs: CoinViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
