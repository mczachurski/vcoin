//
//  CoinRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 18/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct CoinRowView: View {
    var coin: Coin

    var body: some View {
        HStack {
            Text(coin.fullName ?? "")
            Spacer()
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
