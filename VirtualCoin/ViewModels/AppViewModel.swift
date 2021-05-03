//
//  CoinsViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import Foundation
import VirtualCoinKit

public class AppViewModel: ObservableObject {
    @Published public var coins: [CoinViewModel]?
    @Published public var favourites: [CoinViewModel]?
    @Published public var chartData: [Double]?
    
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
        coinCapClient.getChartValuesAsync(chartRange: chartTimeRange,
                                          id: coin.id) { result in
            
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
    
    public func removeFromFavourites(coinViewModel: CoinViewModel) {
        self.favourites = self.favourites?.filter { $0 !== coinViewModel }
    }
    
    public func addToFavourites(coinViewModel: CoinViewModel) {
        self.favourites?.append(coinViewModel)
    }
}
