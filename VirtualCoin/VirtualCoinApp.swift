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
    let coreDataHandler = CoreDataHandler.shared
    var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(appViewModel)
                .environment(\.managedObjectContext, coreDataHandler.container.viewContext)
        }
    }
}
