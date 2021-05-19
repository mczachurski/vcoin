//
//  PreviewData.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 11/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct PreviewData: PreviewProvider {
    
    static func getCoinsViewModel() -> [CoinViewModel] {
        return [
            CoinViewModel(id: "bitcoin", rank: 1, symbol: "BTC", name: "Bitcoin", priceUsd: 53221.21, changePercent24Hr: -2.1),
            CoinViewModel(id: "ethereum", rank: 2, symbol: "ETH", name: "Ethereum", priceUsd: 3211.23, changePercent24Hr: 1.1)
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
        alert.coinSymbol = "BTC"
        alert.currency = "USD"
        alert.isEnabled = true
        alert.isPriceLower = true
        alert.marketCode = ""
        alert.price = 3212.21
        
        return alert
    }
    
    static func getExchangeItem() -> ExchangeItem {
        let exchangeItem = ExchangeItem(context: CoreDataHandler.preview.container.viewContext)
        exchangeItem.coinSymbol = "BTC"
        exchangeItem.amount = 2
        exchangeItem.currency = "USD"
        exchangeItem.marketCode = ""
    
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
    
    static var previews: some View {
        EmptyView()
    }
}
