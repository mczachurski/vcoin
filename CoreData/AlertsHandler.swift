//
//  AlertsHandler.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import CoreData
import Foundation

class AlertsHandler {
    private let timeInterval: TimeInterval = -1 * 24 * 60 * 60

    func createAlertEntity() -> Alert {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        return Alert(context: context)
    }

    func deleteAlertEntity(alert: Alert) {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        context.delete(alert)
    }

    func getActiveAlerts() -> [Alert] {
        var alerts: [Alert] = []

        let context = CoreDataHandler.shared.getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alert")

        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        var date = Date()
        date = date.addingTimeInterval(self.timeInterval)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        guard let minimumAlertDate = calendar.date(from: components) else {
            return alerts
        }

        let predicate = NSPredicate(format: "isEnabled == YES && (alertSentDate == nil || alertSentDate < %@)",
                                    argumentArray: [minimumAlertDate])
        fetchRequest.predicate = predicate

        do {
            if let list = try context.fetch(fetchRequest) as? [Alert] {
                alerts = list
            }
        } catch {
            print("Error during fetching Alert")
        }

        return alerts
    }

    func getAlerts(coinSymbol: String) -> [Alert] {
        var alerts: [Alert] = []

        let context = CoreDataHandler.shared.getManagedObjectContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alert")
        let predicate = NSPredicate(format: "coinSymbol == %@", coinSymbol)
        fetchRequest.predicate = predicate

        do {
            if let list = try context.fetch(fetchRequest) as? [Alert] {
                alerts = list
            }
        } catch {
            print("Error during fetching Alert")
        }

        return alerts
    }
}
