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
    
    @State private var price: NSNumber?
    @State private var selectedCurrency = Currencies.getDefaultCurrency()
    @State private var selectedCoin = CoinViewModel(symbol: "BTC")

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
        
        alert.currency = self.selectedCurrency.symbol
        alert.coinSymbol = self.selectedCoin.symbol
        alert.price = self.price?.doubleValue ?? 0
        alert.marketCode = ""
        alert.isEnabled = true
        
        CoreDataHandler.shared.save()
    }
}

struct AddAlertView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddAlertView()
                .environmentObject(ApplicationStateService.preview)
                .preferredColorScheme(.dark)
            
            AddAlertView()
                .environmentObject(ApplicationStateService.preview)
                .preferredColorScheme(.light)
        }
    }
}
