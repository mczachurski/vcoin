//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
        self.mainBody()
            .navigationTitle("All currencies")
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
    
    @ViewBuilder
    private func mainBody() -> some View {
        switch state {
        case .iddle:
            self.skeletonView()
            .onAppear {
                self.load()
            }
        case .loading:
            self.skeletonView()
        case .loaded:
            if applicationStateService.coins.count > 0 {
                List {
                    ForEach(applicationStateService.coins.filter {
                        searchBar.text.isEmpty || $0.name.localizedStandardContains(searchBar.text)
                    }) { coin in
                        NavigationLink(destination: CoinView(coin: coin)) {
                            CoinRowView(coin: coin)
                        }
                    }
                }
                .add(self.searchBar)
                .listStyle(PlainListStyle())
            } else {
                NoDataView(title: "No Coins", subtitle: "Coins has not been downloaded")
            }
        case .error(let error):
            ErrorView(error: error) {
                self.load()
            }
            .padding()
        }
    }
    
    private func skeletonView() -> some View {
        List(PreviewData.getCoinsViewModel(), id: \.id) { coin in
            NavigationLink(destination: CoinView(coin: coin)) {
                CoinRowView(coin: coin)
            }
        }
        .listStyle(PlainListStyle())
        .redacted(reason: .placeholder)
    }
    
    private func load() {
        if applicationStateService.coins.isEmpty == false {
            self.state = .loaded
            return
        }
        
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
