//
//  AlertRowView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 09/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct AlertRowView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @ObservedObject public var alertViewModel: AlertViewModel
    
    @State var isEnabled: Bool = true
    
    var body: some View {
        HStack {
            CoinImageView(coin: alertViewModel.coinViewModel)
            VStack(alignment: .leading) {
                Text("\(alertViewModel.coinViewModel.name)")
                    .font(.headline)
                Text(alertViewModel.alert.coinSymbol)
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                HStack {
                    Text("Lower then")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text("\(alertViewModel.alert.price.toFormattedPrice(currency: "USD"))")
                        .font(.subheadline)
                    Text(alertViewModel.alert.currency)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing)  {
                Toggle("", isOn: $isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
            }
        }
    }
}

struct AlertRowView_Previews: PreviewProvider {
    static var previews: some View {
        AlertRowView(alertViewModel:
                        AlertViewModel(coinViewModel:
                                        CoinViewModel(id: "bitcoin",
                                                      rank: 1,
                                                      symbol: "BTC",
                                                      name: "Bitcoin",
                                                      priceUsd: 12.1,
                                                      changePercent24Hr: 2),
                                       alert: Alert(),
                                       currency: Currency(id: "USD",
                                                          locale: "en-usd",
                                                          name: "US Dollar")))
    }
}
