//
//  FavouritesView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    @EnvironmentObject private var coinsService: CoinsService
    
    @ObservedObject private var searchBar: SearchBar = SearchBar()
    @State private var showingSettingsView = false
    @State private var state: ViewState = .iddle
    
    var body: some View {
        switch state {
        case .iddle:
            Text("Iddle").onAppear {
                self.load()
            }
        case .loading:
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
            .navigationTitle("Favourites")
        case .loaded:
            List {
                ForEach(applicationStateService.favourites.filter {
                    searchBar.text.isEmpty || $0.name.localizedStandardContains(searchBar.text)
                }) { coin in
                    NavigationLink(destination: CoinView(coin: coin)) {
                        CoinRowView(coin: coin)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Favourites")
            .add(self.searchBar)
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
        case .error(let error):
            Text("\(error.localizedDescription)")
        }
    }
    
    public func load() {
        state = .loading
        
        coinsService.loadFavourites { result in
            DispatchQueue.runOnMain {
                switch result {
                case .success(let coins):
                    self.applicationStateService.favourites = coins
                    self.state = .loaded
                    break;
                case .failure(let error):
                    self.state = .error(error)
                    break;
                }
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                FavouritesView()
                    .environmentObject(ApplicationStateService.preview)
                    .environmentObject(CoinsService.preview)
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                FavouritesView()
                    .environmentObject(ApplicationStateService.preview)
                    .environmentObject(CoinsService.preview)
                    .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
            }
            .preferredColorScheme(.light)
        }
    }
}
