//
//  VirtualCoinApp.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 17/04/2021.
//

import SwiftUI
import VirtualCoinKit

@main
struct VirtualCoinApp: App {
    @Setting(\.isDarkMode) private var isDarkMode: Bool
    @Setting(\.matchSystem) private var matchSystem: Bool

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(ApplicationStateService.shared)
                .environmentObject(CoinsService.shared)
                .environment(\.managedObjectContext, CoreDataHandler.shared.container.viewContext)
                .onAppear {
                    ApplicationStateService.shared.matchSystem = self.matchSystem
                    ApplicationStateService.shared.isDarkMode = self.isDarkMode
                }
        }
    }
}
