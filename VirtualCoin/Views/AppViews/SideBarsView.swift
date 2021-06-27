//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import SwiftUI
import VirtualCoinKit

struct SideBarsView: View {
    @State private var selectedItem: SideBarNavigationItem? = .favourites
    
    var body: some View {
        List {
            
            // Favourites view.
            NavigationLink(
                destination:FavouritesView(),
                tag: SideBarNavigationItem.favourites,
                selection: $selectedItem
            ) {
                Label("Favourites", systemImage: "star.fill")
            }
            
            // All currencies view.
            NavigationLink(
                destination: CoinsView(),
                tag: SideBarNavigationItem.currencies,
                selection: $selectedItem
            ) {
                Label("All currencies", systemImage: "bitcoinsign.circle.fill")
            }

            // Exchanges view.
            NavigationLink(
                destination: ExchangesView(),
                tag: SideBarNavigationItem.exchanges,
                selection: $selectedItem
            ) {
                Label("Exchanges", systemImage: "arrow.triangle.2.circlepath.circle.fill")
            }
            
            // Alerts view.
            NavigationLink(
                destination: AlertsView(),
                tag: SideBarNavigationItem.alerts,
                selection: $selectedItem
            ) {
                Label("Alerts", systemImage: "bell.fill")
            }
            
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Virtual Coin")
    }
}

struct SideBarsView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarsView()
    }
}
