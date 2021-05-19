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
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    @Environment(\.presentationMode) var presentationMode
    
    @State private var amount: NSNumber?
    @State private var selectedCurrency: Currency
    @State private var selectedCoin: CoinViewModel
    
    @ObservedObject private var exchangeViewModel: ExchangeViewModel
    
    init(exchangeViewModel: ExchangeViewModel) {
        self.exchangeViewModel = exchangeViewModel
        
        self._amount = State(initialValue: NSNumber(value: exchangeViewModel.exchangeItem.amount))
        self._selectedCurrency = State(initialValue: Currency(symbol: exchangeViewModel.exchangeItem.currency))
        self._selectedCoin = State(initialValue: CoinViewModel(symbol: exchangeViewModel.exchangeItem.coinSymbol))
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
        self.exchangeViewModel.exchangeItem.currency = self.selectedCurrency.symbol
        self.exchangeViewModel.exchangeItem.coinSymbol = self.selectedCoin.symbol
        self.exchangeViewModel.exchangeItem.amount = self.amount?.doubleValue ?? 0
        self.exchangeViewModel.exchangeItem.marketCode = ""
        
        CoreDataHandler.shared.save()
        
        if let coinViewModel = applicationStateService.coins.first(where: { coinViewModel in
            coinViewModel.symbol == self.exchangeViewModel.exchangeItem.coinSymbol
        }) {
            self.exchangeViewModel.setCoinViewModel(coinViewModel)
        }
        
        if let currency = Currencies.allCurrenciesDictionary[self.exchangeViewModel.exchangeItem.currency] {
            self.exchangeViewModel.setCurrency(currency)
        }
    }
}

struct EditExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditExchangeView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .environmentObject(ApplicationStateService.preview)
                .preferredColorScheme(.dark)
            
            EditExchangeView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .environmentObject(ApplicationStateService.preview)
                .preferredColorScheme(.light)
        }
    }
}
