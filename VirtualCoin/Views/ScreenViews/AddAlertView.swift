//
//  AddAlertView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 09/05/2021.
//

import SwiftUI
import VirtualCoinKit

struct AddAlertView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var price: NSNumber?
    @State private var selectedCurrency = AddAlertView.getCurrency(for: "USD")
    @State private var selectedCoin = AddAlertView.getCoinViewModel(for: "BTC")

    var body: some View {
        NavigationView {
            AlertDetailView(price: $price, currency: $selectedCurrency, coin: $selectedCoin)
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
        .accentColor(.accentColor)
    }
    
    private func saveSettings() {
        let alertsHandler = AlertsHandler()
        let alert = alertsHandler.createAlertEntity()
        
        alert.currency = self.selectedCurrency.id
        alert.coinSymbol = self.selectedCoin.symbol
        alert.price = self.price?.doubleValue ?? 0
        alert.marketCode = ""
        alert.isEnabled = true
        
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

struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddAlertView()
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.dark)
            
            AddAlertView()
                .environmentObject(AppViewModel.preview)
                .preferredColorScheme(.light)
        }
    }
}
