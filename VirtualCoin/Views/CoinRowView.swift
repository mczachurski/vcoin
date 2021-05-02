//
//  CoinRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 18/04/2021.
//

import SwiftUI
import VirtualCoinKit
import URLImage

struct CoinRowView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var coin: CoinViewModel

    var body: some View {
        HStack {
            if let imageUrl = URL(string: coin.imageUrl) {
                URLImage(url: imageUrl, content: { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                })
            }
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
                    .font(.caption)

                Text(coin.changePercent24Hr.toFormattedPercent())
                    .font(.caption)
                    .foregroundColor(coin.changePercent24Hr > 0 ? .green : .red)
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
