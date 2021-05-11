//
//  SideBarsView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 25/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct SideBarsView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var appViewModel: AppViewModel
    
    @Binding var selectedFolder: String?
    
    var body: some View {
        List {
            
            // Favourites view.
            NavigationLink(
                destination:FavouritesView(),
                tag: "favourites",
                selection: $selectedFolder
            ) {
                Label("Favourites", systemImage: "star.fill")
            }
            
            // All currencies view.
            NavigationLink(
                destination: CoinsView(),
                tag: "currencies",
                selection: $selectedFolder
            ) {
                Label("All currencies", systemImage: "bitcoinsign.circle.fill")
            }

            // Exchanges view.
            NavigationLink(
                destination: ExchangesView(),
                tag: "exchanges",
                selection: $selectedFolder
            ) {
                Label("Exchanges", systemImage: "arrow.triangle.2.circlepath.circle.fill")
            }
            
            // Alerts view.
            NavigationLink(
                destination: AlertsView(),
                tag: "alerts",
                selection: $selectedFolder
            ) {
                Label("Alerts", systemImage: "bell.fill")
            }
            
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Menu")
    }
}

struct SideBarsView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarsView(selectedFolder: .constant("favourites"))
            .environmentObject(AppViewModel.preview)
            .environment(\.managedObjectContext, CoreDataHandler.preview.container.viewContext)
    }
}
