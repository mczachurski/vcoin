//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import CoreData
import Foundation
import UIKit

public class CoreDataHandler {
    public static let shared = CoreDataHandler()
    
    public let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "vcoin")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.mczachurski.vcoin") else {
                fatalError("Container URL for application cannot be retrieved")
            }

            let dbUrl = url.appendingPathComponent("Data.sqlite")
            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: dbUrl)]
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    public func save() {
        let context = self.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataHandler {
    public static var preview: CoreDataHandler = {
        let result = CoreDataHandler(inMemory: true)
        let viewContext = result.container.viewContext
        
        let favouriteItem1 = Favourite(context: viewContext)
        favouriteItem1.coinId = "ethereum"

        let favouriteItem2 = Favourite(context: viewContext)
        favouriteItem2.coinId = "bitcoin"

        let favouriteItem3 = Favourite(context: viewContext)
        favouriteItem3.coinId = "dogecoin"
        
        let exchangeItem1 = ExchangeItem(context: viewContext)
        exchangeItem1.coinId = "bitcoin"
        exchangeItem1.amount = 2
        exchangeItem1.currency = "USD"
        
        let alertItem1 = Alert(context: viewContext)
        alertItem1.coinId = "bitcoin"
        alertItem1.currency = "USD"
        alertItem1.isEnabled = true
        alertItem1.isPriceLower = true
        alertItem1.price = 63.33
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
 
        return result
    }()
}
