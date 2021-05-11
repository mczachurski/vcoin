//
//  ExchangeDetailsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 06/05/2021.
//

import SwiftUI
import VirtualCoinKit
import NumericText

struct AddExchangeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var amount: NSNumber?
    @State private var selectedCurrency = AddExchangeView.getCurrency(for: "USD")
    @State private var selectedCoin = AddExchangeView.getCoinViewModel(for: "BTC")
        
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
        let exchangeItemHandler = ExchangeItemsHandler()
        let exchangeItem = exchangeItemHandler.createExchangeItemEntity()
        
        exchangeItem.currency = self.selectedCurrency.id
        exchangeItem.coinSymbol = self.selectedCoin.symbol
        exchangeItem.amount = self.amount?.doubleValue ?? 0
        exchangeItem.marketCode = ""
        
        CoreDataHandler.shared.save()
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

struct AddExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditExchangeView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.dark)
            
            EditExchangeView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.light)
        }
    }
}
