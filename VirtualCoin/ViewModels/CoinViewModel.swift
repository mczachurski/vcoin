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
    public let priceUsd: Double
    public let changePercent24Hr: Double
    public let imageUrl: String
    

    @Published public var isFavourite = false
    
    init(coin: Coin) {
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
        } else {
            self.priceUsd = 0
        }
        
        if let changePercent24Hr = coin.changePercent24Hr, let price = Double(changePercent24Hr) {
            self.changePercent24Hr = price
        } else {
            self.changePercent24Hr = 0
        }
        
        self.imageUrl = "https://static.coincap.io/assets/icons/\(symbol.lowercased())@2x.png"
    }
    
    init(id: String, rank: Int, symbol: String, name: String, priceUsd: Double, changePercent24Hr: Double) {
        self.id = id
        self.rank = rank
        self.symbol = symbol
        self.name = name
        self.priceUsd = priceUsd
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
