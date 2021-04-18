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
    var restClient = RestClient()

    var body: some Scene {
        WindowGroup {
            CoinsView()
                .environmentObject(restClient)
                .environment(\.managedObjectContext, coreDataHandler.container.viewContext)
        }
    }
}
