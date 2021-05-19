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

    @EnvironmentObject private var coinsService: CoinsService
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    
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
            .navigationTitle("All currencies")
        case .loaded:
            List {
                ForEach(applicationStateService.coins.filter {
                    searchBar.text.isEmpty || $0.name.localizedStandardContains(searchBar.text)
                }) { coin in
                    NavigationLink(destination: CoinView(coin: coin)) {
                        CoinRowView(coin: coin)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("All currencies")
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
        
        coinsService.loadCoins { result in
            DispatchQueue.runOnMain {
                switch result {
                case .success(let coins):
                    self.applicationStateService.coins = coins
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

struct CoinsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CoinsView()
                    .environmentObject(ApplicationStateService.preview)
                    .environmentObject(CoinsService.preview)
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                CoinsView()
                    .environmentObject(ApplicationStateService.preview)
                    .environmentObject(CoinsService.preview)
            }
            .preferredColorScheme(.light)
        }
    }
}
