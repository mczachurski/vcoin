//
//  MainView.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 24/04/2021.
//

import SwiftUI
import VirtualCoinKit

struct AppView: View {
    @EnvironmentObject private var applicationStateService: ApplicationStateService
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var selectedFolder: String? = "favourites"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabsView()
                .applyPreferredColorScheme(self.getColorScheme())
        } else {
            NavigationView {
                SideBarsView(selectedFolder: $selectedFolder)
                Text("Primary view")
            }
            .applyPreferredColorScheme(self.getColorScheme())
        }
    }
    
    private func getColorScheme() -> ColorScheme? {
        if applicationStateService.matchSystem {
            return nil
        }
        
        return applicationStateService.isDarkMode ? .dark : .light
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
