//
//  File.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

import CoreData

class WalletItemsHandler {
    
    func createWalletItemEntity() -> WalletItem
    {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        return WalletItem(context: context)
    }
    
    func deleteWalletItemEntity(walletItem: WalletItem) {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        context.delete(walletItem)
    }
    
    func getWalletItems() -> [WalletItem] {
        var walletItems:[WalletItem] = []
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WalletItem")
        do {
            walletItems = try context.fetch(fetchRequest) as! [WalletItem]
        }
        catch {
            print("Error during fetching WalletItem")
        }
        
        return walletItems
    }
}
