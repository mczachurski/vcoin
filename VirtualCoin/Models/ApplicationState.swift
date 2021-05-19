//
//  CoinsViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import Foundation
import SwiftUI
import VirtualCoinKit

public class ApplicationState {
    public static let shared = ApplicationState()
    
    public var coins: [CoinViewModel]?
    public var markets: [MarketViewModel]?
    public var favourites: [CoinViewModel]?
    public var chartData: [Double]?
    
    public var selectedExchangeViewModel: ExchangeViewModel?
    public var selectedAlertViewModel: AlertViewModel?
    
    @Setting(\.currency) public var currencySymbol: String

    public var currencyRateUsd: Double = 1.0
    private var cacheChartData: [String: [Double]] = [:]
    
    public func loadData(completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {
        self.coins = nil
        self.favourites = nil
        
        self.loadCurrencyRate {
            self.loadCoins(completionHandler: completionHandler)
        }
    }
    
    public func loadChartData(coin: CoinViewModel, chartTimeRange: ChartTimeRange, completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {
        var dataResult: [Double] = []

        if let cacheData = self.cacheChartData[coin.symbol + chartTimeRange.rawValue] {
            self.chartData = cacheData
            completionHandler(.success(()))

            return
        }
        
        self.chartData = nil
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
                self.chartData = dataResult
                
                completionHandler(.success(()))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
            
        }
    }
    
    public func loadMarketValues(coin: CoinViewModel, completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {        
        self.markets = nil
        let coinCapClient = CoinCapClient()
        coinCapClient.getMarketValuesAsync(for: coin.id) { result in
            
            switch result {
            case .success(let markets):
                var marketsResult: [MarketViewModel] = []
                
                for market in markets {
                    let marketViewModel = MarketViewModel(market: market, rateUsd: self.currencyRateUsd)
                    marketsResult.append(marketViewModel)
                }
                
                self.markets = marketsResult
                completionHandler(.success(()))
                
                break
            case .failure(let error):
                completionHandler(.failure(error))
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
    
    private func loadCoins(completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {
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
                
                self.coins = coinsResult
                self.favourites = favouritesResult

                completionHandler(.success(()))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
}
