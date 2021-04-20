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
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var cryptoCompareClient: CryptoCompareClient

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.coinSymbol, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Favourite>

    var body: some View {
        NavigationView {
            List(cryptoCompareClient.coins) { coin in
                NavigationLink(destination: CoinView(coin: coin)) {
                    CoinRowView(coin: coin)
                }
            }
            .navigationTitle("Currencies")
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
            .onAppear {
                cryptoCompareClient.loadCoinsList()
            }
        }
    }
}

struct CoinsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsView()
            .environmentObject(CryptoCompareClient())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
