//
//  ExchangeRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 06/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct ExchangeRowView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @ObservedObject public var exchangeViewModel: ExchangeViewModel

    var body: some View {
        ZStack {
            HStack {
                CoinImageView(coin: exchangeViewModel.coinViewModel)
                VStack(alignment: .leading) {
                    Text("\(exchangeViewModel.coinViewModel.name)")
                        .font(.headline)
                    Text("\(exchangeViewModel.exchangeItem.amount)")
                        .font(.subheadline)
                    Text(exchangeViewModel.exchangeItem.coinSymbol)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing)  {
                    Text("\(exchangeViewModel.currency.name)")
                        .font(.headline)
                    Text(exchangeViewModel.price.toFormattedPrice(currency: "USD"))
                        .font(.subheadline)
                    Text(exchangeViewModel.exchangeItem.currency)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            HStack {
                Spacer()
                Image(systemName: "arrow.left.arrow.right")
                Spacer()
            }
        }
    }
}

struct ExchangeRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRowView(exchangeViewModel:
                            ExchangeViewModel(coinViewModel:
                                                CoinViewModel(id: "bitcoin",
                                                              rank: 1,
                                                              symbol: "BTC",
                                                              name: "Bitcoin",
                                                              priceUsd: 12.1,
                                                              changePercent24Hr: 1.2),
                                              exchangeItem: ExchangeItem(),
                                              currency: Currency(id: "USD",
                                                                 locale: "en-US",
                                                                 name: "US Dollar")))
    }
}
