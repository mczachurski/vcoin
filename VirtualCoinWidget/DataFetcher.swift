//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import VirtualCoinKit

class DataFetcher {
    func getCoins(completionHandler: @escaping (Result<[WidgetViewModel], RestClientError>) -> Void) {
        let settingsHandler = SettingsHandler()
        let defaultSettings = settingsHandler.getDefaultSettings()
        
        let coinCapClient = CoinCapClient()
        guard let currency = Currencies.allCurrenciesDictionary[defaultSettings.currency] else {
            completionHandler(.success([]))
            return
        }
                
        coinCapClient.getCurrencyRate(for: currency.id) { currencyResult in
            switch currencyResult {
            case .success(let currencyRate):
                let currencyRateUsd = Double(currencyRate.rateUsd) ?? 1.0
                self.downloadCoins(currencyRateUsd: currencyRateUsd, completionHandler: completionHandler)
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
        
    }
    
    private func downloadCoins(currencyRateUsd: Double, completionHandler: @escaping (Result<[WidgetViewModel], RestClientError>) -> Void) {
        var results: [WidgetViewModel] = []
        let coinOrders = self.getCoinOrders()
        let coinCapClient = CoinCapClient()
        let downloadCoinsGroup = DispatchGroup()
        
        for coinOrder in coinOrders {
            downloadCoinsGroup.enter()

            coinCapClient.getCoinAsync(for: coinOrder.coinId) { coinResult in
                switch coinResult {
                case .success(let coin):
                    
                    let priceUsd = Double(coin.priceUsd ?? "") ?? 0.0
                    let changePercent24Hr = Double(coin.changePercent24Hr ?? "") ?? 0.0
                    
                    results.append(WidgetViewModel(id: coinOrder.coinId,
                                                   order: coinOrder.order,
                                                   rank: Int(coin.rank) ?? 0,
                                                   symbol: coin.symbol,
                                                   name: coin.name,
                                                   priceUsd: priceUsd,
                                                   changePercent24Hr: changePercent24Hr,
                                                   price: priceUsd / currencyRateUsd,
                                                   chart: []))
                
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                    break
                }
                
                downloadCoinsGroup.leave()
            }
        }
        
        downloadCoinsGroup.notify(queue: .main) {
            self.downloadCharts(results: results, completionHandler: completionHandler)
        }
    }
    
    private func downloadCharts(results: [WidgetViewModel], completionHandler: @escaping (Result<[WidgetViewModel], RestClientError>) -> Void) {
        var resultsMutating = results
        let downloadChartsGroup = DispatchGroup()
        let coinCapClient = CoinCapClient()
        
        for resultIndex in resultsMutating.indices {
            
            downloadChartsGroup.enter()
            coinCapClient.getChartValuesAsync(for: resultsMutating[resultIndex].id, withRange: .hour) { chartResult in
                switch chartResult {
                case .success(let chartValues):
                    
                    var dataResult: [Double] = []
                    for chartValue in chartValues {
                        if let value = Double(chartValue.priceUsd) {
                            dataResult.append(value)
                        }
                    }
                    
                    resultsMutating[resultIndex].chart = dataResult
                
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                    break
                }
                
                downloadChartsGroup.leave()
            }
        }
        
        downloadChartsGroup.notify(queue: .main) {
            let resultOrdered = resultsMutating.sorted(by: { lhs, rhs in
                lhs.order < rhs.order
            })

            completionHandler(.success(resultOrdered))
        }
    }
    
    private func getCoinOrders() -> [CoinOrder] {
        let favouritesHandler = FavouritesHandler()
        let favourites = favouritesHandler.getFavourites()
        
        // Get coins from favourites.
        var coinOrders = favourites.map { favourite in
            CoinOrder(coinId: favourite.coinId, order: favourite.order)
        }
        
        var maxOrder = coinOrders.map { coinOrder in coinOrder.order }.max() ?? 0
        
        // Add other higher rank coins for nice widget.
        for widgetViewModel in PreviewData.getWidgetViewModels() {
            if coinOrders.contains(where: { coinOrder in coinOrder.coinId == widgetViewModel.id }) {
                continue
            }
            
            coinOrders.append(CoinOrder(coinId: widgetViewModel.id, order: maxOrder))
            maxOrder = maxOrder + 1
        }
        
        return coinOrders
    }
}
