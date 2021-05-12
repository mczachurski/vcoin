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
    @State private var isShowingMarketsView = false
    
    var body: some View {
        VStack {
            HStack {
                CoinImageView(coin: coin)
                Text(coin.name)
                    .font(.largeTitle)
                    .fontWeight(.thin)
            }.padding(.trailing, 32)
            
            Text(coin.symbol)
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(.gray)

            Text(coin.price.toFormattedPrice(currency: appViewModel.currencySymbol))
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
                    isShowingMarketsView.toggle()
                }) {
                    Image(systemName: "globe")
                }
                .disabled(appViewModel.markets == nil)
                .sheet(isPresented: $isShowingMarketsView) {
                    MarketsView(markets: appViewModel.markets!)
                }
                
                Button(action: {
                    self.toggleFavourite();
                }) {
                    Image(systemName: coin.isFavourite ? "star.fill" : "star")
                }
            }
        }
        .onAppear {
            appViewModel.loadMarketValues(coin: coin)
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
        Group {
            NavigationView {
                CoinView(coin: PreviewData.getCoinViewModel())
                    .environmentObject(AppViewModel.preview)
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                CoinView(coin: PreviewData.getCoinViewModel())
                    .environmentObject(AppViewModel.preview)
            }
            .preferredColorScheme(.light)
        }
    }
}
