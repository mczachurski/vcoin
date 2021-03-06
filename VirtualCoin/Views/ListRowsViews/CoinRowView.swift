//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit

struct CoinRowView: View {
    @ObservedObject var coin: CoinViewModel
    @Setting(\.currency) private var currencySymbol: String
    
    var body: some View {

        HStack {
            CoinImageView(coin: coin)
            
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol)
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(coin.price.toFormattedPrice(currency: currencySymbol))
                    .font(.subheadline)
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
            CoinRowView(coin: PreviewData.getCoinViewModel())
                .preferredColorScheme(.dark)

            CoinRowView(coin: PreviewData.getCoinViewModel())
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
