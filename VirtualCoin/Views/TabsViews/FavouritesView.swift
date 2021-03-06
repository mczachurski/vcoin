//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    @EnvironmentObject private var coinsService: CoinsService
    
    @State private var showingSettingsView = false
    @State private var state: ViewState = .iddle
    
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
            if applicationStateService.favourites.count > 0 {
                List {
                    ForEach(applicationStateService.favourites) { coin in
                        NavigationLink(destination: CoinView(coin: coin)) {
                            CoinRowView(coin: coin)
                        }
                    }.onMove(perform: self.move)
                }
                .toolbar {
                    EditButton()
                }
                .listStyle(PlainListStyle())
            } else {
                NoDataView(title: "No Favourites", subtitle: "Select your favourite coins")
            }
        case .error(let error):
            ErrorView(error: error) {
                self.load()
            }
            .padding()
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        // Get favourites form core data.
        let favouritesHandler = FavouritesHandler()
        var favourites: [Favourite] = favouritesHandler.getFavourites()

        // Change order in core data array.
        favourites.move(fromOffsets: source, toOffset: destination)

        // Update the userOrder attribute in revisedItems to persist the new order.
        // This is done in reverse order to minimize changes to the indices.
        for reverseIndex in stride(from: favourites.count - 1, through: 0, by: -1 ) {
            favourites[reverseIndex].order = Int32(reverseIndex)
        }
        
        // Save new order.
        CoreDataHandler.shared.save()
        
        // Change also order in array stored in application state.
        self.applicationStateService.favourites.move(fromOffsets: source, toOffset: destination)
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
