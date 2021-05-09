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
    
    private var cacheChartData: [String: [Double]] = [:]
    
    public func loadCoins() {
        let coinCapClient = CoinCapClient()
        coinCapClient.getCoinsAsync { result in
            switch result {
            case .success(let coins):
                var coinsResult: [CoinViewModel] = []
                var favouritesResult: [CoinViewModel] = []
                
                let favouritesHandler = FavouritesHandler()
                let favourites = favouritesHandler.getFavourites()
                
                for coin in coins {
                    let coinViewModel = CoinViewModel(coin: coin)
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
    
    public func loadChartData(coin: CoinViewModel, chartTimeRange: ChartTimeRange) {
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
        DispatchQueue.main.async {
            self.markets = nil
        }

        let coinCapClient = CoinCapClient()
        coinCapClient.getMarketValuesAsync(for: coin.id) { result in
            
            switch result {
            case .success(let markets):
                var marketsResult: [MarketViewModel] = []
                
                for market in markets {
                    let marketViewModel = MarketViewModel(market: market)
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
}
