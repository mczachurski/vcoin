//
//  ApplicationStateService.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 19/05/2021.
//

import Foundation

public class ApplicationStateService: ObservableObject {
    public static let shared = ApplicationStateService()

    @Published public var coins: [CoinViewModel] = []
    @Published public var markets: [MarketViewModel] = []
    @Published public var favourites: [CoinViewModel] = []
    @Published public var currencyRateUsd: Double = 1.0
    
    public var selectedExchangeViewModel: ExchangeViewModel?
    public var selectedAlertViewModel: AlertViewModel?
}

extension ApplicationStateService {
    public func removeFromFavourites(coinViewModel: CoinViewModel) {
        self.favourites = self.favourites.filter { $0 !== coinViewModel }
    }
    
    public func addToFavourites(coinViewModel: CoinViewModel) {
        self.favourites.append(coinViewModel)

        self.favourites = self.favourites.sorted(by: { lhs, rhs in
            lhs.rank < rhs.rank
        })
    }
}

extension ApplicationStateService {
    public static var preview: ApplicationStateService = {
        let applicationStateService = ApplicationStateService()
        
        applicationStateService.coins = PreviewData.getCoinsViewModel()
        applicationStateService.favourites = PreviewData.getCoinsViewModel()
        applicationStateService.markets = PreviewData.getMarketsViewModel()
        
        return applicationStateService
    }()
}
