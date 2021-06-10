//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import SwiftUI

struct MarketRowView: View {
    @StateObject var market: MarketViewModel
    @Setting(\.currency) private var currencySymbol: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(market.id)
                    .font(.headline)
                Text("\(market.baseSymbol) / \(market.quoteSymbol)")
                    .font(.footnote)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            Text(market.price.toFormattedPrice(currency: currencySymbol))
                .font(.footnote)
        }
    }
}

struct MarketRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MarketRowView(market: PreviewData.getMarketViewModel())
                .preferredColorScheme(.dark)
            
            MarketRowView(market: PreviewData.getMarketViewModel())
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
