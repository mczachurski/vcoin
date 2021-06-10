//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
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
        Group {
            CoinImageView(coin: PreviewData.getCoinViewModel())
                .preferredColorScheme(.dark)

            CoinImageView(coin: PreviewData.getCoinViewModel())
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 32, height: 32))
    }
}
