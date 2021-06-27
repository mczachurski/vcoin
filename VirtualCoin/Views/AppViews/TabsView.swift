//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import VirtualCoinKit

struct TabsView: View {

    var body: some View {
        TabView {

            // Favourites view.
            NavigationView {
                FavouritesView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favourites")
            }

            // All currencies view.
            NavigationView {
                CoinsView()
            }
            .tabItem {
                Image(systemName: "bitcoinsign.circle.fill")
                Text("All currencies")
            }
            
            // Exchanges view.
            NavigationView {
                ExchangesView()
            }
            .tabItem {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                Text("Exchanges")
            }
            
            // Alerts view.
            NavigationView {
                AlertsView()
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Alerts")
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
