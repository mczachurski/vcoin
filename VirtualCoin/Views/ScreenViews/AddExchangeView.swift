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
    
    @State private var amount: NSNumber?
    @State private var selectedCurrency = Currencies.getDefaultCurrency()
    @State private var selectedCoin = CoinViewModel(symbol: "BTC")
        
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
        
        exchangeItem.currency = self.selectedCurrency.symbol
        exchangeItem.coinSymbol = self.selectedCoin.symbol
        exchangeItem.amount = self.amount?.doubleValue ?? 0
        exchangeItem.marketCode = ""
        
        CoreDataHandler.shared.save()
    }
}

struct AddExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditExchangeView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .preferredColorScheme(.dark)
            
            EditExchangeView(exchangeViewModel: PreviewData.getExchangeViewModel())
                .preferredColorScheme(.light)
        }
    }
}
