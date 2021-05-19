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
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(ApplicationStateService())
                .environmentObject(CoinsService.shared)
                .environment(\.managedObjectContext, CoreDataHandler.shared.container.viewContext)
        }
    }
}
