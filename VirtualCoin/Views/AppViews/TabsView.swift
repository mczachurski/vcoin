//
//  MainView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 24/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct TabsView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView {

            // Favourites view.
            NavigationView {
                FavouritesView()
                    .environmentObject(appViewModel)
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favourites")
            }

            // All currencies view.
            NavigationView {
                CoinsView()
                    .environmentObject(appViewModel)
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .tabItem {
                Image(systemName: "bitcoinsign.circle.fill")
                Text("All currencies")
            }
            
            // Exchanges view.
            NavigationView {
                ExchangesView()
                    .environmentObject(appViewModel)
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .tabItem {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                Text("Exchanges")
            }
            
            // Alerts view.
            NavigationView {
                AlertsView()
                    .environmentObject(appViewModel)
                    .environment(\.managedObjectContext, managedObjectContext)
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
            .environmentObject(AppViewModel())
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
