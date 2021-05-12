//
//  CoinsViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import Foundation
import SwiftUI
import VirtualCoinKit

public class AppViewModel: ObservableObject {
    @Published public var coins: [CoinViewModel]?
    @Published public var markets: [MarketViewModel]?
    @Published public var favourites: [CoinViewModel]?
    @Published public var chartData: [Double]?
    
    @Published public var selectedExchangeViewModel: ExchangeViewModel?
    @Published public var selectedAlertViewModel: AlertViewModel?
    
    public var currencySymbol: String = "USD"
    public var currencyRateUsd: Double = 1.0
    private var cacheChartData: [String: [Double]] = [:]
    private let inMemory: Bool
    
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    public func loadData() {
        if inMemory {
            return
        }
        
        self.coins = nil
        self.favourites = nil

        let settingsHandler = SettingsHandler()
        let settings = settingsHandler.getDefaultSettings()
        
        if settings.currency.count > 0 {
            self.currencySymbol = settings.currency
        }
        
        self.loadCurrencyRate {
            self.loadCoins()
        }
    }
    
    public func loadChartData(coin: CoinViewModel, chartTimeRange: ChartTimeRange) {
        if inMemory {
            return
        }
        
        var dataResult: [Double] = []

        if let cacheData = self.cacheChartData[coin.symbol + chartTimeRange.rawValue] {
            DispatchQueue.main.async {
                self.chartData = cacheData
            }

            return
        }
        
        DispatchQueue.main.async {
            self.chartData = nil
        }

        let coinCapClient = CoinCapClient()
        coinCapClient.getChartValuesAsync(for: coin.id, withRange: chartTimeRange) { result in
            
            switch result {
            case .success(let chartValues):
                for chartValue in chartValues {
                    if let value = Double(chartValue.priceUsd) {
                        dataResult.append(value)
                    }
                }
                
                self.cacheChartData[coin.symbol + chartTimeRange.rawValue] = dataResult
                
                DispatchQueue.main.async {
                    self.chartData = dataResult
                }
                
                break
            case .failure(let error):
                // TODO: Show something in UI.
                print(error)
                break
            }
            
        }
    }
    
    public func loadMarketValues(coin: CoinViewModel) {
        if inMemory {
            return
        }
        
        DispatchQueue.main.async {
            self.markets = nil
        }

        let coinCapClient = CoinCapClient()
        coinCapClient.getMarketValuesAsync(for: coin.id) { result in
            
            switch result {
            case .success(let markets):
                var marketsResult: [MarketViewModel] = []
                
                for market in markets {
                    let marketViewModel = MarketViewModel(market: market, rateUsd: self.currencyRateUsd)
                    marketsResult.append(marketViewModel)
                }
                
                DispatchQueue.main.async {
                    self.markets = marketsResult
                }
                
                break
            case .failure(let error):
                // TODO: Show something in UI.
                print(error)
                break
            }
        }
    }
    
    public func removeFromFavourites(coinViewModel: CoinViewModel) {
        self.favourites = self.favourites?.filter { $0 !== coinViewModel }
    }
    
    public func addToFavourites(coinViewModel: CoinViewModel) {
        self.favourites?.append(coinViewModel)

        self.favourites = self.favourites?.sorted(by: { lhs, rhs in
            lhs.rank < rhs.rank
        })
    }
    
    private func loadCurrencyRate(completionHandler: @escaping () -> Void) {
        let coinCapClient = CoinCapClient()

        if let currency = Currencies.allCurrenciesDictionary[self.currencySymbol] {
            coinCapClient.getCurrencyRate(for: currency.id) { result in
                switch result {
                case .success(let currencyRate):
                    self.currencyRateUsd = Double(currencyRate.rateUsd) ?? 1.0
                    break
                case .failure(let error):
                    // TODO: Show something in UI.
                    print(error)
                    break
                }
                
                completionHandler()
            }
        }
    }
    
    private func loadCoins() {
        let coinCapClient = CoinCapClient()
        coinCapClient.getCoinsAsync { result in
            switch result {
            case .success(let coins):
                var coinsResult: [CoinViewModel] = []
                var favouritesResult: [CoinViewModel] = []
                
                let favouritesHandler = FavouritesHandler()
                let favourites = favouritesHandler.getFavourites()
                
                for coin in coins {                    
                    let coinViewModel = CoinViewModel(coin: coin, rateUsd: self.currencyRateUsd)
                    coinsResult.append(coinViewModel)
                    
                    if favourites.contains(where: { favourite in
                        favourite.coinSymbol == coinViewModel.symbol
                    }) {
                        coinViewModel.isFavourite = true
                        favouritesResult.append(coinViewModel)
                    }
                }
                
                DispatchQueue.main.async {
                    self.coins = coinsResult
                    self.favourites = favouritesResult
                }
                
                break
            case .failure(let error):
                // TODO: Show something in UI.
                print(error)
                break
            }
        }
    }
    
    public static var preview: AppViewModel = {
        let result = AppViewModel(inMemory: true)

        result.coins = [
            CoinViewModel(id: "bitcoin", rank: 1, symbol: "BTC", name: "Bitcoin", priceUsd: 53221.21, changePercent24Hr: -2.1),
            CoinViewModel(id: "ethereum", rank: 2, symbol: "ETH", name: "Ethereum", priceUsd: 3211.23, changePercent24Hr: 1.1)
        ]
        
        result.favourites = [
            CoinViewModel(id: "bitcoin", rank: 1, symbol: "BTC", name: "Bitcoin", priceUsd: 53221.21, changePercent24Hr: -2.1),
            CoinViewModel(id: "ethereum", rank: 2, symbol: "ETH", name: "Ethereum", priceUsd: 3211.23, changePercent24Hr: 1.1)
        ]
        
        result.chartData = [3212.02, 3292.01, 3296.83, 3222.73, 3298.74, 3265.32, 3287.73, 3287.32, 3301.83, 3301.74, 3403.21, 3502.92]
        
        return result
    }()
}
