//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import SwiftUI
import VirtualCoinKit

public class CoinsService: ObservableObject {
    public static let shared = CoinsService()
    
    private let inMemory: Bool
    private var marketsCache: [MarketViewModel]?
    private var chartDataCache: [Double]?
    private var currencyRateUsdCache: Double = 1.0
    private var cacheChartData: [String: [Double]] = [:]
    
    @Setting(\.currency) private var currencySymbol: String
    
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    public func loadCoins(into applicationStateService: ApplicationStateService,
                          completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {
        if inMemory {
            completionHandler(.success(()))
            return
        }
        
        self.loadCurrencyRate(into: applicationStateService) { result in
            switch result {
            case .success:
                self.loadCoinsInternal(into: applicationStateService, completionHandler: completionHandler)
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }

    public func loadMarketValues(into applicationStateService: ApplicationStateService,
                                 coin: CoinViewModel,
                                 completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {
        if inMemory {
            completionHandler(.success(()))
            return
        }
        
        self.marketsCache = nil
        let coinCapClient = CoinCapClient()
        coinCapClient.getMarketValuesAsync(for: coin.id) { result in
            
            switch result {
            case .success(let markets):
                var marketsResult: [MarketViewModel] = []
                
                for market in markets {
                    let marketViewModel = MarketViewModel(market: market, rateUsd: self.currencyRateUsdCache)
                    marketsResult.append(marketViewModel)
                }
                
                self.marketsCache = marketsResult
                
                DispatchQueue.runOnMain {
                    applicationStateService.markets = self.marketsCache ?? []
                }
                
                completionHandler(.success(()))
                
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    public func getChartData(coin: CoinViewModel,
                             chartTimeRange: ChartTimeRange,
                             completionHandler: @escaping (Result<[Double], RestClientError>) -> Void) {
        if inMemory {
            completionHandler(.success(self.chartDataCache ?? []))
            return
        }
        
        var dataResult: [Double] = []

        if let cacheData = self.cacheChartData[coin.symbol + chartTimeRange.rawValue] {
            self.chartDataCache = cacheData
            completionHandler(.success(self.chartDataCache ?? []))

            return
        }
        
        self.chartDataCache = nil
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
                self.chartDataCache = dataResult

                completionHandler(.success(self.chartDataCache ?? []))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    private func loadCurrencyRate(into applicationStateService: ApplicationStateService,
                                  completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {
        let coinCapClient = CoinCapClient()

        if let currency = Currencies.allCurrenciesDictionary[self.currencySymbol] {
            coinCapClient.getCurrencyRate(for: currency.id) { result in
                switch result {
                case .success(let currencyRate):
                    self.currencyRateUsdCache = Double(currencyRate.rateUsd) ?? 1.0
                    
                    DispatchQueue.runOnMain {
                        applicationStateService.currencyRateUsd = self.currencyRateUsdCache
                    }

                    completionHandler(.success(()))
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                    break
                }
            }
        }
    }
    
    private func loadCoinsInternal(into applicationStateService: ApplicationStateService,
                                   completionHandler: @escaping (Result<Void, RestClientError>) -> Void) {
        let coinCapClient = CoinCapClient()
        coinCapClient.getCoinsAsync { result in
            switch result {
            case .success(let coins):
   
                if applicationStateService.coins.count == 0 {
                    self.addCoins(to: applicationStateService, basedOn: coins)
                } else {
                    self.refreshCoins(in: applicationStateService, basedOn: coins)
                }
                
                completionHandler(.success(()))

                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    private func addCoins(to applicationStateService: ApplicationStateService,
                          basedOn coins: [Coin]) {
        var coinsResult: [CoinViewModel] = []
        var favouritesResult: [CoinViewModel] = []
        
        let favouritesHandler = FavouritesHandler()
        let favourites = favouritesHandler.getFavourites()
        
        for coin in coins {
            let coinViewModel = CoinViewModel(coin: coin)
            coinViewModel.refresh(priceUsd: coin.priceUsd, changePercent24Hr: coin.changePercent24Hr, withRateUsd: self.currencyRateUsdCache)

            coinsResult.append(coinViewModel)
            
            if favourites.contains(where: { favourite in
                favourite.coinId == coinViewModel.id
            }) {
                coinViewModel.isFavourite = true
            }
        }
        
        for favourite in favourites {
            if let coinViewModel = coinsResult.first(where: { coin in
                favourite.coinId == coin.id
            }) {
                favouritesResult.append(coinViewModel)
            }
        }
        
        DispatchQueue.runOnMain {
            applicationStateService.coins = coinsResult
            applicationStateService.favourites = favouritesResult
        }
    }
    
    private func refreshCoins(in applicationStateService: ApplicationStateService,
                              basedOn coins: [Coin]) {
        for coin in coins {
            if let existingCoin = applicationStateService.coins.first(where: { coinViewModel in
                coinViewModel.id == coin.id
            }) {
                DispatchQueue.runOnMain {
                    existingCoin.refresh(priceUsd: coin.priceUsd, changePercent24Hr: coin.changePercent24Hr, withRateUsd: self.currencyRateUsdCache)
                }
            }
        }
    }
}

extension CoinsService {
    public static var preview: CoinsService = {
        let result = CoinsService(inMemory: true)
        
        result.marketsCache = PreviewData.getMarketsViewModel()
        result.chartDataCache = PreviewData.getChartData()
        
        return result
    }()
}
