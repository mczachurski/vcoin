//
//  ContentView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 17/04/2021.
//

import SwiftUI
import CoreData
import VirtualCoinKit

struct CoinsView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var cryptoCompareClient: CryptoCompareClient
    
    var title: String

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.coinSymbol, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Favourite>

    var body: some View {
        if cryptoCompareClient.coins.count == 0 {
            Text("Loading...")
                .onAppear {
                    cryptoCompareClient.loadCoinsList()
                }
        }
        else {
            List(cryptoCompareClient.coins) { coin in
                NavigationLink(destination: CoinView(coin: coin)) {
                    CoinRowView(coin: coin)
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Edit button was tapped")
                    }) {
                        Image(systemName: "switch.2")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Edit button was tapped")
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    }
                }
            }
        }
    }
}

struct CoinsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsView(title: "Favourites")
            .environmentObject(CryptoCompareClient())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
