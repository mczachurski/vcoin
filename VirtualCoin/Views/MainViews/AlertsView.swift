//
//  AlertsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI

struct AlertsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showingSettingsView = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Alert.coinSymbol, ascending: true)],
        animation: .default
    )
    private var alerts: FetchedResults<Alert>
    
    var body: some View {
        List(alerts, id: \.objectID) { alert in
            Text(alert.coinSymbol)
//            NavigationLink(destination: CoinView(coin: coin)) {
//                CoinRowView(coin: coin)
//            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Alerts")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showingSettingsView.toggle()
                }) {
                    Image(systemName: "switch.2")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Add button was tapped")
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingSettingsView) {
            SettingsView()
        }
    }
}

struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView()
            .environmentObject(AppViewModel())
    }
}
