//
//  MainView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 24/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct AppView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var selectedFolder: String? = "favourites"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabsView()
                .onAppear {
                    appViewModel.loadData()
                }
        } else {
            NavigationView {
                SideBarsView(selectedFolder: $selectedFolder)
                Text("Primary view")
            }
            .onAppear {
                appViewModel.loadData()
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(AppViewModel.preview)
    }
}
