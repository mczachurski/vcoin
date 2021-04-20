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
    var cryptoCompareClient = CryptoCompareClient()

    var body: some Scene {
        WindowGroup {
            CoinsView()
                .environmentObject(cryptoCompareClient)
                .environment(\.managedObjectContext, coreDataHandler.container.viewContext)
        }
    }
}
