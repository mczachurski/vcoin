//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit

struct AddAlertView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var price: NSNumber?
    @State private var isPriceLower: Bool = true
    @State private var selectedCurrency = Currencies.getDefaultCurrency()
    @State private var selectedCoin = CoinViewModel(symbol: "BTC")

    var body: some View {
        NavigationView {
            AlertDetailView(price: $price, isPriceLower: $isPriceLower, currency: $selectedCurrency, coin: $selectedCoin)
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
        let alertsHandler = AlertsHandler()
        let alert = alertsHandler.createAlertEntity()
        
        alert.currency = self.selectedCurrency.symbol
        alert.coinId = self.selectedCoin.id
        alert.coinSymbol = self.selectedCoin.symbol
        alert.price = self.price?.doubleValue ?? 0
        alert.isEnabled = true
        alert.isPriceLower = self.isPriceLower
        
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
