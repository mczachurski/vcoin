//
//  MainView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 24/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct MainView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject var cryptoCompareClient: CryptoCompareClient
    
    @State private var selectedFolder: String? = "currencies"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabsView()
                .environmentObject(cryptoCompareClient)
                .environment(\.managedObjectContext, managedObjectContext)
        } else {
            NavigationView {
                SideBarsView(selectedFolder: $selectedFolder)
                Text("Primary view")
                // Text("Detail view")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
