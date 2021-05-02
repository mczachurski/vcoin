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
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var selectedFolder: String? = "currencies"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabsView()
                .environmentObject(appViewModel)
                .environment(\.managedObjectContext, managedObjectContext)
                .onAppear {
                    appViewModel.loadCoins()
                }
        } else {
            NavigationView {
                SideBarsView(selectedFolder: $selectedFolder)
                Text("Primary view")
                // Text("Detail view")
            }
            .onAppear {
                appViewModel.loadCoins()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
