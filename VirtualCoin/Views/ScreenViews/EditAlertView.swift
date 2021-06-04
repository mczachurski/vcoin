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
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    @Environment(\.presentationMode) var presentationMode
    
    @State private var price: NSNumber?
    @State private var selectedCurrency: Currency
    @State private var selectedCoin: CoinViewModel
    
    @ObservedObject private var alertViewModel: AlertViewModel
    
    init(alertViewModel: AlertViewModel) {
        self.alertViewModel = alertViewModel
        
        self._price = State(initialValue: NSNumber(value: alertViewModel.alert.price))
        self._selectedCurrency = State(initialValue: Currency(symbol: alertViewModel.alert.currency))
        self._selectedCoin = State(initialValue: CoinViewModel(id: alertViewModel.alert.coinId))
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
        self.alertViewModel.alert.currency = self.selectedCurrency.symbol
        self.alertViewModel.alert.coinId = self.selectedCoin.id
        self.alertViewModel.alert.coinSymbol = self.selectedCoin.symbol
        self.alertViewModel.alert.price = self.price?.doubleValue ?? 0
        
        CoreDataHandler.shared.save()
        
        if let coinViewModel = applicationStateService.coins.first(where: { coinViewModel in
            coinViewModel.id == self.alertViewModel.alert.coinId
        }) {
            self.alertViewModel.setCoinViewModel(coinViewModel)
        }
        
        if let currency = Currencies.allCurrenciesDictionary[self.alertViewModel.alert.currency] {
            self.alertViewModel.setCurrency(currency)
        }
    }
}

struct EEditAlertView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditAlertView(alertViewModel: PreviewData.getAlertViewModel())
                .environmentObject(ApplicationStateService.preview)
                .preferredColorScheme(.dark)
            
            EditAlertView(alertViewModel: PreviewData.getAlertViewModel())
                .environmentObject(ApplicationStateService.preview)
                .preferredColorScheme(.light)
        }
    }
}
