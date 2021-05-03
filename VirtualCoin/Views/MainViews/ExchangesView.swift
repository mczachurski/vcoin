//
//  ExchangesView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 03/05/2021.
//

import SwiftUI

struct ExchangesView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showingSettingsView = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExchangeItem.coinSymbol, ascending: true)],
        animation: .default
    )
    private var exchanges: FetchedResults<Alert>
    
    var body: some View {
        List(exchanges, id: \.objectID) { exchange in
            Text(exchange.coinSymbol)
//            NavigationLink(destination: CoinView(coin: coin)) {
//                CoinRowView(coin: coin)
//            }
        }
        .navigationTitle("Exchanges")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showingSettingsView.toggle()
                }) {
                    Image(systemName: "switch.2")
                }
                .sheet(isPresented: $showingSettingsView) {
                    SettingsView()
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
    }
}

struct ExchangesView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangesView()
            .environmentObject(AppViewModel())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
