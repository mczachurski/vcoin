//
//  CoinImageView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI
import URLImage

struct CoinImageView: View {
    var coin: CoinViewModel

    var body: some View {
        if let imageUrl = URL(string: coin.imageUrl) {
            URLImage(
                url: imageUrl,
                empty: {
                    InitialsPlaceholder(text: coin.name)
                        .frame(width: 32, height: 32, alignment: .center)
                },
                inProgress: { progress in
                    InitialsPlaceholder(text: coin.name)
                        .frame(width: 32, height: 32, alignment: .center)
                },
                failure: { error, retry in
                    InitialsPlaceholder(text: coin.name)
                        .frame(width: 32, height: 32, alignment: .center)
                },
                content: { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                }
            )
        } else {
            InitialsPlaceholder(text: coin.name)
                .frame(width: 32, height: 32, alignment: .center)
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: CoinViewModel(id: "bitcoin",
                                          rank: "1",
                                          symbol: "BTC",
                                          name: "Bitcoin",
                                          priceUsd: 6929.821775,
                                          changePercent24Hr: -0.81014))
            .previewLayout(.fixed(width: 32, height: 32))
    }
}
