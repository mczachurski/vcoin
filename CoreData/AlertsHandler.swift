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
    
    func getActiveAlerts() -> [Alert] {
        var alerts:[Alert] = []
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alert")
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        var date = Date()
        date = date.addingTimeInterval(-1*24*60*60)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let minimumAlertDate = calendar.date(from: components)
        
        let predicate = NSPredicate(format: "isEnabled == YES && (alertSentDate == nil || alertSentDate < %@)", argumentArray: [minimumAlertDate!])
        fetchRequest.predicate = predicate
        
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
