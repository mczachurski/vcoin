//
//  SettingsHandler.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class SettingsHandler {
    func getDefaultSettings() -> Settings {
        var settingsList: [Settings] = []

        let context = CoreDataHandler.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do {
            if let list = try context.fetch(fetchRequest) as? [Settings] {
                settingsList = list
            }
        } catch {
            print("Error during fetching favourites")
        }

        if let settings = settingsList.first {
            if settings.currency.count == 0 {
                settings.currency = "USD"
            }
            
            return settings
        } else {
            let settings = self.createSettingsEntity()
            settings.currency = "USD"
            settings.isDarkMode = false
            CoreDataHandler.shared.save()

            return settings
        }
    }

    private func createSettingsEntity() -> Settings {
        let context = CoreDataHandler.shared.container.viewContext
        return Settings(context: context)
    }
}
