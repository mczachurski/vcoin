//
//  CoinsViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import Foundation
import SwiftUI
import VirtualCoinKit

public class CoinsService: ObservableObject {
    public static let shared = CoinsService()
    
    private let inMemory: Bool
    private var coins: [CoinViewModel]?
    private var markets: [MarketViewModel]?
    private var favourites: [CoinViewModel]?
    private var chartData: [Double]?
    
    public var selectedExchangeViewModel: ExchangeViewModel?
    public var selectedAlertViewModel: AlertViewModel?
    
    @Setting(\.currency) public var currencySymbol: String

    public var currencyRateUsd: Double = 1.0
    private var cacheChartData: [String: [Double]] = [:]
    
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    public func loadCoins(completionHandler: @escaping (Result<[CoinViewModel], RestClientError>) -> Void) {
        if inMemory {
            completionHandler(.success(self.coins ?? []))
            return
        }
        
        self.coins = nil
        self.favourites = nil
        
        self.loadCurrencyRate {
            self.loadCoinsInternal(completionHandler: completionHandler)
        }
    }

    public func loadFavourites(completionHandler: @escaping (Result<[CoinViewModel], RestClientError>) -> Void) {
        if inMemory {
            completionHandler(.success(self.coins ?? []))
            return
        }
        
        self.coins = nil
        self.favourites = nil
        
        self.loadCurrencyRate {
            self.loadFavouritesInternal(completionHandler: completionHandler)
        }
    }
    
    public func loadChartData(coin: CoinViewModel, chartTimeRange: ChartTimeRange, completionHandler: @escaping (Result<[Double], RestClientError>) -> Void) {
        if inMemory {
            completionHandler(.success(self.chartData ?? []))
            return
        }
        
        var dataResult: [Double] = []

        if let cacheData = self.cacheChartData[coin.symbol + chartTimeRange.rawValue] {
            self.chartData = cacheData
            completionHandler(.success(self.chartData ?? []))

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

                completionHandler(.success(self.chartData ?? []))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
            
        }
    }
    
    public func loadMarketValues(coin: CoinViewModel, completionHandler: @escaping (Result<[MarketViewModel], RestClientError>) -> Void) {
        if inMemory {
            completionHandler(.success(self.markets ?? []))
            return
        }
        
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
                completionHandler(.success(self.markets ?? []))
                
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
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
    
    private func loadCoinsInternal(completionHandler: @escaping (Result<[CoinViewModel], RestClientError>) -> Void) {
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
                
                completionHandler(.success(self.coins ?? []))

                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    private func loadFavouritesInternal(completionHandler: @escaping (Result<[CoinViewModel], RestClientError>) -> Void) {
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
                
                completionHandler(.success(self.favourites ?? []))

                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
}

extension CoinsService {
    public static var preview: CoinsService = {
        let result = CoinsService(inMemory: true)
        
        result.coins = PreviewData.getCoinsViewModel()
        result.favourites = PreviewData.getCoinsViewModel()
        result.markets = PreviewData.getMarketsViewModel()
        result.chartData = PreviewData.getChartData()
        
        return result
    }()
}
