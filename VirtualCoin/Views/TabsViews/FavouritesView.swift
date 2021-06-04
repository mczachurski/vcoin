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
    
    @Setting(\.isDarkMode) private var isDarkMode: Bool
    @Setting(\.matchSystem) private var matchSystem: Bool
    
    var body: some View {
        self.mainBody()
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
                    .applyPreferredColorScheme(self.getColorScheme())
                    .onDisappear {
                         applicationStateService.isDarkMode = self.isDarkMode
                         applicationStateService.matchSystem = self.matchSystem
                    }
            }
    }
    
    private func getColorScheme() -> ColorScheme? {
        if applicationStateService.matchSystem {
            return nil
        }
        
        return applicationStateService.isDarkMode ? .dark : .light
    }
    
    private func mainBody() -> some View {
        Group {
            switch state {
            case .iddle:
                Text("").onAppear {
                    self.load()
                }
            case .loading:
                LoadingView()
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
                .add(self.searchBar)
            case .error(let error):
                ErrorView(error: error) {
                    self.load()
                }
                .padding()
            }
        }
    }
    
    private func load() {
        state = .loading
        
        coinsService.loadCoins(into: applicationStateService) { result in
            DispatchQueue.runOnMain {
                switch result {
                case .success:
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
