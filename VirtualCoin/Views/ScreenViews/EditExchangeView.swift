//
//  ExchangeDetailsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 06/05/2021.
//

import SwiftUI
import VirtualCoinKit
import NumericText

struct EditExchangeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var amount: NSNumber?
    @State private var selectedCurrency: Currency
    @State private var selectedCoin: CoinViewModel
    
    @ObservedObject private var exchangeViewModel: ExchangeViewModel
    
    init(exchangeViewModel: ExchangeViewModel) {
        self.exchangeViewModel = exchangeViewModel
        
        self._amount = State(initialValue: NSNumber(value: exchangeViewModel.exchangeItem.amount))

        self._selectedCurrency = State(initialValue:
            EditExchangeView.getCurrency(for: exchangeViewModel.exchangeItem.currency))

        self._selectedCoin = State(initialValue:
            EditExchangeView.getCoinViewModel(for: exchangeViewModel.exchangeItem.coinSymbol))
    }
    
    var body: some View {
        NavigationView {
            ExchangeDetailView(amount: self.$amount, currency: self.$selectedCurrency, coin: self.$selectedCoin)
            .navigationBarTitle(Text("Exchange"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel").bold()
                },
                trailing: Button(action: {
                    self.saveSettings()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold()
                })
        }
    }
    
    private func saveSettings() {
        self.exchangeViewModel.exchangeItem.currency = self.selectedCurrency.id
        self.exchangeViewModel.exchangeItem.coinSymbol = self.selectedCoin.symbol
        self.exchangeViewModel.exchangeItem.amount = self.amount?.doubleValue ?? 0
        self.exchangeViewModel.exchangeItem.marketCode = ""
        
        CoreDataHandler.shared.save()
        
        if let coinViewModel = self.appViewModel.coins?.first(where: { coinViewModel in
            coinViewModel.symbol == self.exchangeViewModel.exchangeItem.coinSymbol
        }) {
            self.exchangeViewModel.setCoinViewModel(coinViewModel)
        }
        
        if let currency = Currencies.allCurrenciesDictionary[self.exchangeViewModel.exchangeItem.currency] {
            self.exchangeViewModel.setCurrency(currency)
        }
    }
    
    private static func getCoinViewModel(for symbol: String) -> CoinViewModel {
        CoinViewModel(id: "",
                      rank: 0,
                      symbol: symbol,
                      name: "",
                      priceUsd: 0,
                      changePercent24Hr: 0)
    }
    
    private static func getCurrency(for currency: String) -> Currency {
        Currency(id: currency, locale: "", name: "")
    }
}

struct EditExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        EditExchangeView(exchangeViewModel:
                            ExchangeViewModel(coinViewModel: CoinViewModel(id: "bitcoin",
                                                                           rank: 1,
                                                                           symbol: "BTC",
                                                                           name: "Bitcoin",
                                                                           priceUsd: 12.1,
                                                                           changePercent24Hr: 2.1),
                                              exchangeItem: ExchangeItem(),
                                              currency: Currency(id: "USD",
                                                                 locale: "en-US",
                                                                 name: "US Dollar")))
    }
}
