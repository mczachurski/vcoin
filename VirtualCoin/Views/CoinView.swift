//
//  CoinView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 20/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct CoinView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var coin: CoinViewModel

    var body: some View {
        Text("Coin details: \(coin.name)")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Edit button was tapped")
                }) {
                    Image(systemName: "globe")
                }
                
                Button(action: {
                    self.toggleFavourite();
                }) {
                    Image(systemName: coin.isFavourite ? "star.fill" : "star")
                }
                
                Button(action: {
                    print("Edit button was tapped")
                }) {
                    Image(systemName: "bell.fill")
                }
            }
        }
    }
    
    private func toggleFavourite() {
        let favouritesHandler = FavouritesHandler()
        
        if favouritesHandler.isFavourite(symbol: coin.symbol) {
            self.coin.isFavourite = false
            self.appViewModel.removeFromFavourites(coinViewModel: coin)

            favouritesHandler.deleteFavouriteEntity(symbol: coin.symbol)
        } else {
            self.coin.isFavourite = true
            self.appViewModel.addToFavourites(coinViewModel: coin)
            
            let favouriteEntity = favouritesHandler.createFavouriteEntity()
            favouriteEntity.coinSymbol = coin.symbol
        }
        
        CoreDataHandler.shared.save()
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(coin: CoinViewModel(id: "bitcoin",
                                     rank: "1",
                                     symbol: "BTC",
                                     name: "Bitcoin",
                                     priceUsd: 6929.821775,
                                     changePercent24Hr: -0.81014))
    }
}
