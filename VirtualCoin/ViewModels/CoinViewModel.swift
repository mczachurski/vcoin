//
//  CoinViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import Foundation
import VirtualCoinKit

public class CoinViewModel: Identifiable, ObservableObject {
    public let id: String
    public let rank: Int
    public let symbol: String
    public let name: String
    public let imageUrl: String

    @Published public var price: Double
    @Published public var isFavourite = false
    @Published public var priceUsd: Double
    @Published public var changePercent24Hr: Double
    
    init(coin: Coin, rateUsd: Double) {
        self.id = coin.id
        self.symbol = coin.symbol
        self.name = coin.name
        
        if let rank = Int(coin.rank) {
            self.rank = rank
        } else {
            self.rank = 0
        }
        
        if let priceUsd = coin.priceUsd, let price = Double(priceUsd) {
            self.priceUsd = price
            self.price = price / rateUsd
        } else {
            self.priceUsd = 0
            self.price = 0
        }
        
        if let changePercent24Hr = coin.changePercent24Hr, let price = Double(changePercent24Hr) {
            self.changePercent24Hr = price
        } else {
            self.changePercent24Hr = 0
        }
        
        self.imageUrl = "https://static.coincap.io/assets/icons/\(symbol.lowercased())@2x.png"
    }
    
    init(id: String = "bitcoin", rank: Int = 1, symbol: String = "BTC", name: String = "Bitcoin", priceUsd: Double = 0.0, changePercent24Hr: Double = 0.0) {
        self.id = id
        self.rank = rank
        self.symbol = symbol
        self.name = name
        self.priceUsd = priceUsd
        self.price = priceUsd
        self.changePercent24Hr = changePercent24Hr
        self.imageUrl = "https://static.coincap.io/assets/icons/\(symbol.lowercased())@2x.png"
    }
}

extension CoinViewModel: Hashable {
    public static func == (lhs: CoinViewModel, rhs: CoinViewModel) -> Bool {
        return lhs.symbol == rhs.symbol
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.symbol)
    }
}
