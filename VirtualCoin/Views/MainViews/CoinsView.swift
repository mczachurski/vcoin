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
    @EnvironmentObject var appViewModel: AppViewModel

    @ObservedObject var searchBar: SearchBar = SearchBar()
    @State private var showingSettingsView = false

    var body: some View {
        if let coins = appViewModel.coins {
            List {
                ForEach(coins.filter {
                    searchBar.text.isEmpty || $0.name.localizedStandardContains(searchBar.text)
                }) { coin in
                    NavigationLink(destination: CoinView(coin: coin)) {
                        CoinRowView(coin: coin)
                    }
                }
            }
            .navigationTitle("All currencies")
            .add(self.searchBar)
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
            }
        }
        else {
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
            .navigationTitle("All currencies")
        }
    }
}

struct CoinsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsView()
            .environmentObject(AppViewModel())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
