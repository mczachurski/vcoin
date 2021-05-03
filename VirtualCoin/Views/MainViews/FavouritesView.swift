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

    var body: some View {
        if let favourites = appViewModel.favourites {
            List(favourites) { coin in
                NavigationLink(destination: CoinView(coin: coin)) {
                    CoinRowView(coin: coin).environmentObject(appViewModel)
                }
            }
            .navigationTitle("Favourites")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Settings button was tapped")
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
