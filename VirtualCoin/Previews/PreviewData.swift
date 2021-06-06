//
//  PreviewData.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 11/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct PreviewData {
    
    static func getCoinsViewModel() -> [CoinViewModel] {
        return [
            CoinViewModel(id: "bitcoin", rank: 1, symbol: "BTC", name: "Bitcoin", priceUsd: 36135.11, changePercent24Hr: -4.72),
            CoinViewModel(id: "ethereum", rank: 2, symbol: "ETH", name: "Ethereum", priceUsd: 2662.72, changePercent24Hr: -4.43),
            CoinViewModel(id: "dogecoin", rank: 3, symbol: "DOGE", name: "Dogecoin", priceUsd: 0.37526429, changePercent24Hr: -5.18),
            CoinViewModel(id: "cardano", rank: 4, symbol: "USDT", name: "Cardano", priceUsd: 1.69, changePercent24Hr: -5.18),
            CoinViewModel(id: "tether", rank: 5, symbol: "USDT", name: "Tether", priceUsd: 1.00, changePercent24Hr: 0.03),
            CoinViewModel(id: "xrp", rank: 6, symbol: "XRP", name: "XRP", priceUsd: 0.94153174, changePercent24Hr: -5.35),
            CoinViewModel(id: "uniswap", rank: 7, symbol: "UNI", name: "Uniswap", priceUsd: 25.98, changePercent24Hr: -5.28),
            CoinViewModel(id: "litecoin", rank: 8, symbol: "LTC", name: "Litecoin", priceUsd: 175.35, changePercent24Hr: -3.78),
            CoinViewModel(id: "chainlink", rank: 9, symbol: "LINK", name: "Chainlink", priceUsd: 27.65, changePercent24Hr: -7.53),
            CoinViewModel(id: "binance-usd", rank: 10, symbol: "BUSD", name: "Binance USD", priceUsd: 1.00, changePercent24Hr: 0.04),
            CoinViewModel(id: "stellar", rank: 11, symbol: "XLM", name: "Stellar", priceUsd: 0.38132001, changePercent24Hr: -4.78),
            CoinViewModel(id: "vechain", rank: 12, symbol: "VET", name: "VeChain", priceUsd: 0.12897915, changePercent24Hr: -5.77),
            CoinViewModel(id: "matic-network", rank: 13, symbol: "MATIC", name: "Matic Network", priceUsd: 1.57, changePercent24Hr: -8.23),
            CoinViewModel(id: "ethereum-classic", rank: 14, symbol: "MATIC", name: "Ethereum Classic", priceUsd: 63.85, changePercent24Hr: -4.17)
        ]
    }
    
    static func getCoinViewModel() -> CoinViewModel {
        CoinViewModel(id: "bitcoin",
                      rank: 1,
                      symbol: "BTC",
                      name: "Bitcoin",
                      priceUsd: 6929.821775,
                      changePercent24Hr: -0.81014)
    }

    static func getMarketsViewModel() -> [MarketViewModel] {
        return [
            MarketViewModel(id: "Kraken",
                        baseSymbol: "BTC",
                        quoteSymbol: "EUR",
                        priceUsd: 67211.23,
                        price: 12321.33),
            MarketViewModel(id: "BitShop",
                        baseSymbol: "BTC",
                        quoteSymbol: "EUR",
                        priceUsd: 65211.23,
                        price: 12341.22),
        ]
    }
    
    static func getMarketViewModel() -> MarketViewModel {
        MarketViewModel(id: "Kraken",
                        baseSymbol: "BTC",
                        quoteSymbol: "EUR",
                        priceUsd: 67211.23,
                        price: 12321.33)
    }
    
    static func getAlert() -> Alert {
        let alert = Alert(context: CoreDataHandler.preview.container.viewContext)
        alert.coinId = "bitcoin"
        alert.currency = "USD"
        alert.isEnabled = true
        alert.isPriceLower = true
        alert.price = 3212.21
        
        return alert
    }
    
    static func getExchangeItem() -> ExchangeItem {
        let exchangeItem = ExchangeItem(context: CoreDataHandler.preview.container.viewContext)
        exchangeItem.coinId = "bitcoin"
        exchangeItem.amount = 2
        exchangeItem.currency = "USD"
    
        return exchangeItem
    }
    
    static func getCurrency() -> Currency {
        Currency(id: "united-states-dollar", symbol: "USD", locale: "en-US", name: "US Dollar")
    }
    
    static func getExchangeViewModel() -> ExchangeViewModel {
        ExchangeViewModel(coinViewModel: getCoinViewModel(),
                                 exchangeItem: getExchangeItem(),
                                 currency: getCurrency())
    }
    
    static func getAlertViewModel() -> AlertViewModel {
        AlertViewModel(coinViewModel: getCoinViewModel(),
                       alert: getAlert(),
                       currency: getCurrency())
    }
    
    static func getChartData() -> [Double] {
        return [34, 34, 23, 34, 45, 65, 34, 32, 23, 33, 65, 57, 65, 34, 65, 67]
    }
}
