//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit
import NumericText

struct ExchangeDetailView: View {
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    
    @Binding private var amount: NSNumber?
    @Binding private var selectedCurrency: Currency
    @Binding private var selectedCoin: CoinViewModel
    
    init(amount: Binding<NSNumber?>, currency: Binding<Currency>, coin: Binding<CoinViewModel>) {
        _amount = amount
        _selectedCurrency = currency
        _selectedCoin = coin
    }
    
    var body: some View {
        List {
            Section(header: Text("VALUES")) {
                HStack {
                    Text("Amount")
                    NumericTextField("Amount",
                                     number: $amount,
                                     isDecimalAllowed: true,
                                     numberFormatter: NumberFormatter.amountFormatter)
                        .multilineTextAlignment(.trailing)
                }
                
                Picker(selection: $selectedCoin, label: Text("Coin")) {
                    ForEach(applicationStateService.coins, id: \.self) { coin in
                        HStack {
                            Text(coin.name)
                                .font(.body)
                            Text("(\(coin.symbol))")
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                        }.tag(coin)
                    }
                }
                
                Picker(selection: $selectedCurrency, label: Text("Currency")) {
                    ForEach(Currencies.allCurrenciesList, id: \.self) { currency in
                        HStack {
                            Text(currency.name)
                                .font(.body)
                            Text("(\(currency.symbol))")
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                        }.tag(currency)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct ExchangeDetailView_Previews: PreviewProvider {
    @State private static var amount: NSNumber? = 12.32
    @State private static var currency = PreviewData.getCurrency()
    @State private static var coin = PreviewData.getCoinViewModel()

    static var previews: some View {
        ExchangeDetailView(amount: $amount, currency: $currency, coin: $coin)
            .environmentObject(ApplicationStateService.preview)
    }
}
