//
//  ExchangeDetailsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 06/05/2021.
//

import SwiftUI
import VirtualCoinKit
import NumericText

struct EditAlertView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var price: NSNumber?
    @State private var selectedCurrency: Currency
    @State private var selectedCoin: CoinViewModel
    
    @ObservedObject private var alertViewModel: AlertViewModel
    
    init(alertViewModel: AlertViewModel) {
        self.alertViewModel = alertViewModel
        
        self._price = State(initialValue: NSNumber(value: alertViewModel.alert.price))

        self._selectedCurrency = State(initialValue:
                                        EditAlertView.getCurrency(for: alertViewModel.alert.currency))

        self._selectedCoin = State(initialValue:
                                    EditAlertView.getCoinViewModel(for: alertViewModel.alert.coinSymbol))
    }
    
    var body: some View {
        NavigationView {
            AlertDetailView(price: self.$price, currency: self.$selectedCurrency, coin: self.$selectedCoin)
            .navigationBarTitle(Text("Alert"), displayMode: .inline)
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
        self.alertViewModel.alert.currency = self.selectedCurrency.id
        self.alertViewModel.alert.coinSymbol = self.selectedCoin.symbol
        self.alertViewModel.alert.price = self.price?.doubleValue ?? 0
        
        CoreDataHandler.shared.save()
        
        if let coinViewModel = self.appViewModel.coins?.first(where: { coinViewModel in
            coinViewModel.symbol == self.alertViewModel.alert.coinSymbol
        }) {
            self.alertViewModel.setCoinViewModel(coinViewModel)
        }
        
        if let currency = Currencies.allCurrenciesDictionary[self.alertViewModel.alert.currency] {
            self.alertViewModel.setCurrency(currency)
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

struct EEditAlertView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlertView(alertViewModel:
                        AlertViewModel(coinViewModel: CoinViewModel(id: "bitcoin",
                                                                    rank: 1,
                                                                    symbol: "BTC",
                                                                    name: "Bitcoin",
                                                                    priceUsd: 12.1,
                                                                    changePercent24Hr: 2.1),
                                       alert: Alert(),
                                       currency: Currency(id: "USD",
                                                          locale: "en-US",
                                                          name: "US Dollar")))
    }
}
