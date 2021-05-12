//
//  MarketRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 05/05/2021.
//

import SwiftUI

struct MarketRowView: View {
    @EnvironmentObject var appViewModel: AppViewModel
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
            
            Text(market.price.toFormattedPrice(currency: appViewModel.currencySymbol))
                .font(.footnote)
        }
    }
}

struct MarketRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MarketRowView(market: PreviewData.getMarketViewModel())
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.dark)
            
            MarketRowView(market: PreviewData.getMarketViewModel())
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.light)
        }
        .previewLayout(.fixed(width: 360, height: 70))
    }
}
