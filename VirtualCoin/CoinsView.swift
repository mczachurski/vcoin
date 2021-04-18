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
    @EnvironmentObject var restClient: RestClient

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.coinSymbol, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Favourite>

    var body: some View {
        List(restClient.coins) { coin in
            CoinRowView(coin: coin)
        }
        .onAppear {
            restClient.loadCoinsList()
        }
    }
}

struct CoinsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsView()
            .environmentObject(RestClient())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
