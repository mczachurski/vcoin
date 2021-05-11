//
//  ExchangeDetailView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 08/05/2021.
//

import SwiftUI
import VirtualCoinKit
import NumericText

struct AlertDetailView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @Binding private var price: NSNumber?
    @Binding private var selectedCurrency: Currency
    @Binding private var selectedCoin: CoinViewModel
    
    init(price: Binding<NSNumber?>, currency: Binding<Currency>, coin: Binding<CoinViewModel>) {
        _price = price
        _selectedCurrency = currency
        _selectedCoin = coin
    }
    
    var body: some View {
        List {
            Section(header: Text("VALUES")) {
                HStack {
                    Text("Price")
                    NumericTextField("Price", number: $price, isDecimalAllowed: true)
                        .multilineTextAlignment(.trailing)
                }
                
                Picker(selection: $selectedCoin, label: Text("Coin")) {
                    ForEach(appViewModel.coins ?? [], id: \.self) { coin in
                        HStack {
                            Text(coin.name)
                                .font(.body)
                            Text("(\(coin.symbol))")
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                        }.tag(coin)
                   }
                }.onChange(of: selectedCurrency, perform: { value in
                    print("selected: \(value.id)")
                })
                
                Picker(selection: $selectedCurrency, label: Text("Currency")) {
                    ForEach(Currencies.allCurrenciesList, id: \.self) { currency in
                        HStack {
                            Text(currency.name)
                                .font(.body)
                            Text("(\(currency.id))")
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                        }.tag(currency)
                   }
                }.onChange(of: selectedCurrency, perform: { value in
                    print("selected: \(value.id)")
                })
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct AlertDetailView_Previews: PreviewProvider {
    @State private static var price: NSNumber? = 21.2
    @State private static var currency = PreviewData.getCurrency()
    @State private static var coin = PreviewData.getCoinViewModel()

    static var previews: some View {
        AlertDetailView(price: $price, currency: $currency, coin: $coin)
            .environmentObject(AppViewModel.preview)
    }
}
