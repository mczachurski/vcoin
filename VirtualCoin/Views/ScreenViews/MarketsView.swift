//
//  MarketsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 05/05/2021.
//

import SwiftUI

struct MarketsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel    
    public var markets: [MarketViewModel]
    
    var body: some View {
        NavigationView {
            List(markets) { market in
                MarketRowView(market: market)
            }
            .navigationBarTitle(Text("Markets"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done").bold()
            })
        }
    }
}

struct MarketsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MarketsView(markets: [PreviewData.getMarketViewModel()])
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.dark)
            
            MarketsView(markets: [PreviewData.getMarketViewModel()])
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.light)
        }
    }
}
