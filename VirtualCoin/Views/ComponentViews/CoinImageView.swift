//
//  CoinImageView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI
import URLImage

struct CoinImageView: View {
    var imageUrl: String

    var body: some View {
        if let imageUrl = URL(string: imageUrl) {
            URLImage(
                url: imageUrl,
                empty: {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                },
                inProgress: { progress in
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                },
                failure: { error, retry in
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                },
                content: { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                }
            )
        } else {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(imageUrl: "https://static.coincap.io/assets/icons/btc@2x.png")
            .previewLayout(.fixed(width: 32, height: 32))
    }
}
