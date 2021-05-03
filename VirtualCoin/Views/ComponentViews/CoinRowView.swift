//
//  CoinRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 18/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct CoinRowView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var coin: CoinViewModel
    
    var body: some View {

        HStack {
            CoinImageView(imageUrl: coin.imageUrl)
            
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.body)
                Text(coin.symbol)
                    .font(.footnote)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(coin.priceUsd.toFormattedPrice(currency: "USD"))
                    .font(.footnote)
                    .foregroundColor(coin.changePercent24Hr > 0 ?.greenPastel : .redPastel)

                Text(coin.changePercent24Hr.toFormattedPercent())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: CoinViewModel(id: "bitcoin",
                                            rank: "1",
                                            symbol: "BTC",
                                            name: "Bitcoin",
                                            priceUsd: 6929.821775,
                                            changePercent24Hr: -0.81014))

            CoinRowView(coin: CoinViewModel(id: "ethereum",
                                            rank: "2",
                                            symbol: "ETH",
                                            name: "Ethereum",
                                            priceUsd: 404.9774667,
                                            changePercent24Hr: -0.099962))
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
