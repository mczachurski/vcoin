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
    @EnvironmentObject var cryptoCompareClient: CryptoCompareClient
    
    @Binding var selectedFolder: String?
    
    var body: some View {
        List {
            
            // Favourites view
            NavigationLink(
                destination: CoinsView(title: "Favourites")
                    .environmentObject(cryptoCompareClient)
                    .environment(\.managedObjectContext, managedObjectContext),
                tag: "favourites",
                selection: $selectedFolder
            ) {
                Label("Favourites", systemImage: "book.closed")
            }
            
            // All currencies view
            NavigationLink(
                destination: CoinsView(title: "All currencies")
                    .environmentObject(cryptoCompareClient)
                    .environment(\.managedObjectContext, managedObjectContext),
                tag: "currencies",
                selection: $selectedFolder
            ) {
                Label("All currencies", systemImage: "book.closed")
            }

            // Exchange view
            NavigationLink(
                destination: Text("Exchanges view"),
                tag: "exchanges",
                selection: $selectedFolder
            ) {
                Label("Exchanges", systemImage: "book.closed")
            }
            
            // Alerts view
            NavigationLink(
                destination: Text("Alerts view"),
                tag: "alerts",
                selection: $selectedFolder
            ) {
                Label("Alerts", systemImage: "book.closed")
            }
            
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Menu")
    }
}

//struct SideBarsView_Previews: PreviewProvider {
//    @State private var selectedFolder: String? = "favourites"
//
//    static var previews: some View {
//        SideBarsView(selectedFolder: $selectedFolder)
//    }
//}
