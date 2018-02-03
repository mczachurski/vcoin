//
//  AlertsHandler.swift
//  VCoin
//
//  Created by Marcin Czachurski on 01.02.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import CoreData

class AlertsHandler {
    
    func createAlertntity() -> Alert
    {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        return Alert(context: context)
    }
    
    func deleteAlertEntity(alert: Alert) {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        context.delete(alert)
    }
    
    func getAlerts() -> [Alert] {
        var alerts:[Alert] = []
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alert")        
        do {
            alerts = try context.fetch(fetchRequest) as! [Alert]
        }
        catch {
            print("Error during fetching Alert")
        }
        
        return alerts
    }
    
    func getAlerts(coinSymbol: String) -> [Alert] {
        var alerts:[Alert] = []
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alert")
        let predicate = NSPredicate(format: "coinSymbol == %@", coinSymbol)
        fetchRequest.predicate = predicate
        
        do {
            alerts = try context.fetch(fetchRequest) as! [Alert]
        }
        catch {
            print("Error during fetching Alert")
        }
        
        return alerts
    }
}
