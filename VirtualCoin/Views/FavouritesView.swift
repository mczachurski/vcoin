//
//  FavouritesView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import SwiftUI

struct FavouritesView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var appViewModel: AppViewModel

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.coinSymbol, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Favourite>

    var body: some View {
        if let favourites = appViewModel.favourites {
            List(favourites) { coin in
                NavigationLink(destination: CoinView(coin: coin)) {
                    CoinRowView(coin: coin)
                        .environmentObject(appViewModel)
                }
            }
            .navigationTitle("Favourites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Edit button was tapped")
                    }) {
                        Image(systemName: "switch.2")
                    }
                }
            }
        }
        else {
            Text("Loading...")
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
            .environmentObject(AppViewModel())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
