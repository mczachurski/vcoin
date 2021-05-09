//
//  MarketRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 05/05/2021.
//

import SwiftUI

struct MarketRowView: View {
    @StateObject var market: MarketViewModel

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
            
            Text(market.priceUsd.toFormattedPrice(currency: "USD"))
                .font(.footnote)
        }
    }
}

struct MarketRowView_Previews: PreviewProvider {
    static var previews: some View {
        MarketRowView(market: MarketViewModel(id: "Kraken",
                                              baseSymbol: "BTC",
                                              quoteSymbol: "EUR",
                                              priceUsd: 67211.23))
    }
}
