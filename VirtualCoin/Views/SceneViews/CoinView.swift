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

    @State private var selectedTab: ChartTimeRange = .hour
    
    var body: some View {
        VStack {
            HStack {
                CoinImageView(imageUrl: coin.imageUrl)
                Text(coin.name)
                    .font(.largeTitle)
                    .fontWeight(.thin)
            }.padding(.trailing, 32)
            
            Text(coin.symbol)
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(Color.gray)

            Text(coin.priceUsd.toFormattedPrice(currency: "USD"))
                .fontWeight(.light)
                .font(.title)

            Text(coin.changePercent24Hr.toFormattedPercent())
                .font(.body)
                .foregroundColor(coin.changePercent24Hr > 0 ? .greenPastel : .redPastel)

            VStack {
                Picker("", selection: $selectedTab) {
                    Text(ChartTimeRange.hour.rawValue).tag(ChartTimeRange.hour)
                    Text(ChartTimeRange.day.rawValue).tag(ChartTimeRange.day)
                    Text(ChartTimeRange.week.rawValue).tag(ChartTimeRange.week)
                    Text(ChartTimeRange.month.rawValue).tag(ChartTimeRange.month)
                    Text(ChartTimeRange.year.rawValue).tag(ChartTimeRange.year)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                switch(selectedTab) {
                case .hour:
                    ChartView(chartTimeRange: .hour, coin: self.coin)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .day:
                    ChartView(chartTimeRange: .day, coin: self.coin)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .week:
                    ChartView(chartTimeRange: .week, coin: self.coin)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .month:
                    ChartView(chartTimeRange: .month, coin: self.coin)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .year:
                    ChartView(chartTimeRange: .year, coin: self.coin)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
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
        NavigationView {
            CoinView(coin: CoinViewModel(id: "bitcoin",
                                         rank: "1",
                                         symbol: "BTC",
                                         name: "Bitcoin",
                                         priceUsd: 6929.821775,
                                         changePercent24Hr: -0.81014))
                .environmentObject(AppViewModel())
        }
    }
}
