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
    
    public func loadCoins() {
        let coinCapClient = CoinCapClient()
        coinCapClient.loadCoins { result in
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
    
    public func removeFromFavourites(coinViewModel: CoinViewModel) {
        self.favourites = self.favourites?.filter { $0 !== coinViewModel }
    }
    
    public func addToFavourites(coinViewModel: CoinViewModel) {
        self.favourites?.append(coinViewModel)
    }
}
