//
//  CoinView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 20/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct CoinView<VM, CVM>: View where VM: CoinViewViewModelProtocol, CVM: ChartViewViewModelProtocol {
    @ObservedObject var viewModel: VM

    @State private var selectedTab: ChartTimeRange = .hour
    @State private var isShowingMarketsView = false
        
    var body: some View {
        VStack {
            HStack {
                CoinImageView(coin: viewModel.coin)
                Text(viewModel.coin.name)
                    .font(.largeTitle)
                    .fontWeight(.thin)
            }.padding(.trailing, 32)
            
            Text(viewModel.coin.symbol)
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(.gray)

            Text(viewModel.coin.price.toFormattedPrice(currency: ApplicationState.shared.currencySymbol))
                .fontWeight(.light)
                .font(.title)

            Text(viewModel.coin.changePercent24Hr.toFormattedPercent())
                .font(.body)
                .foregroundColor(viewModel.coin.changePercent24Hr > 0 ? .greenPastel : .redPastel)

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
                    ChartView(viewModel: CVM.init(chartTimeRange: .hour, coin: viewModel.coin))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .day:
                    ChartView(viewModel: CVM.init(chartTimeRange: .day, coin: viewModel.coin))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .week:
                    ChartView(viewModel: CVM.init(chartTimeRange: .week, coin: viewModel.coin))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .month:
                    ChartView(viewModel: CVM.init(chartTimeRange: .month, coin: viewModel.coin))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .year:
                    ChartView(viewModel: CVM.init(chartTimeRange: .year, coin: viewModel.coin))
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
                .disabled(ApplicationState.shared.markets == nil)
                .sheet(isPresented: $isShowingMarketsView) {
                    MarketsView(markets: ApplicationState.shared.markets!)
                }
                
                Button(action: {
                    self.toggleFavourite();
                }) {
                    Image(systemName: viewModel.coin.isFavourite ? "star.fill" : "star")
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
    
    private func toggleFavourite() {
        let favouritesHandler = FavouritesHandler()
        
        if favouritesHandler.isFavourite(symbol: viewModel.coin.symbol) {
            self.viewModel.coin.isFavourite = false
            ApplicationState.shared.removeFromFavourites(coinViewModel: viewModel.coin)

            favouritesHandler.deleteFavouriteEntity(symbol: viewModel.coin.symbol)
        } else {
            self.viewModel.coin.isFavourite = true
            ApplicationState.shared.addToFavourites(coinViewModel: viewModel.coin)
            
            let favouriteEntity = favouritesHandler.createFavouriteEntity()
            favouriteEntity.coinSymbol = viewModel.coin.symbol
        }
        
        CoreDataHandler.shared.save()
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CoinView<MockCoinViewViewModel, MockChartViewViewModel>(viewModel: MockCoinViewViewModel(coin: PreviewData.getCoinViewModel()))
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                CoinView<MockCoinViewViewModel, MockChartViewViewModel>(viewModel: MockCoinViewViewModel(coin: PreviewData.getCoinViewModel()))
            }
            .preferredColorScheme(.light)
        }
    }
}
