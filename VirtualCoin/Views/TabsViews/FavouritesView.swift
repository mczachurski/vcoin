//
//  FavouritesView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import SwiftUI

struct FavouritesView: View {
    @State private var showingSettingsView = false

    var body: some View {
        if let favourites = ApplicationState.shared.favourites {
            List(favourites) { coin in
                NavigationLink(destination: CoinView<CoinViewViewModel, ChartViewViewModel>(viewModel: CoinViewViewModel(coin: coin))) {
                    CoinRowView(coin: coin)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Favourites")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingSettingsView.toggle()
                    }) {
                        Image(systemName: "switch.2")
                    }
                }
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
        }
        else {
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
            .navigationTitle("Favourites")
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                FavouritesView()
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                FavouritesView()
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.light)
        }
    }
}
