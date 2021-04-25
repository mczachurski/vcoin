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
    @EnvironmentObject var cryptoCompareClient: CryptoCompareClient
    
    var body: some View {
        TabView {

//            // Favourites view
//            NavigationView {
//                CoinsView(title: "Favourites")
//                    .environmentObject(cryptoCompareClient)
//                    .environment(\.managedObjectContext, managedObjectContext)
//            }
//            .tabItem {
//                Image(systemName: "phone.fill")
//                Text("Favourites")
//            }
//
            // All currencies view
            NavigationView {
                CoinsView(title: "All currencies")
                    .environmentObject(cryptoCompareClient)
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .tabItem {
                Image(systemName: "tv.fill")
                Text("All currencies")
            }
            
            // Exchanges view
            NavigationView {
                Text("Exchanges view")
            }
            .tabItem {
                Image(systemName: "tv.fill")
                Text("Exchanges")
            }
            
            // Alerts view
            NavigationView {
                Text("Alerts view")
            }
            .tabItem {
                Image(systemName: "tv.fill")
                Text("Alrets")
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
