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
    var coin: Coin

    var body: some View {
        HStack {
            if let imageString = coin.imageUrl,
               let imageUrl = URL(string: "https://cryptocompare.com" + imageString) {
                URLImage(url: imageUrl, content: { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                })
            }
            VStack(alignment: .leading) {
                Text(coin.coinName ?? "")
                    .font(.body)
                Text(coin.symbol)
                    .font(.footnote)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$32.32")
                    .font(.body)
                Text("-0.34%")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: Coin(data: ["FullName": "Bitcoin"]))
            CoinRowView(coin: Coin(data: ["FullName": "Ethereum"]))
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
