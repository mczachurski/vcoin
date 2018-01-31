//
//  File.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import CoreData

class ExchangeItemsHandler {
    
    func createExchangeItemEntity() -> ExchangeItem
    {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        return ExchangeItem(context: context)
    }
    
    func deleteExchangeItemEntity(exchangeItem: ExchangeItem) {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        context.delete(exchangeItem)
    }
    
    func getExchangeItems() -> [ExchangeItem] {
        var exchangeItems:[ExchangeItem] = []
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExchangeItem")
        do {
            exchangeItems = try context.fetch(fetchRequest) as! [ExchangeItem]
        }
        catch {
            print("Error during fetching ExchangeItem")
        }
        
        return exchangeItems
    }
}
