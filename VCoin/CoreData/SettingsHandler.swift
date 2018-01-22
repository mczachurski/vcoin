//
//  SettingsHandler.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SettingsHandler : CoreDataHandler {
    
    func getDefaultSettings() -> Settings {
        
        var settingsList:[Settings] = []
        
        let context = self.getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do {
            settingsList = try context.fetch(fetchRequest) as! [Settings]
        }
        catch {
            print("Error during fetching favourites")
        }
        
        var settings:Settings? = nil
        if settingsList.count == 0 {
            settings = self.createSettingsEntity()
            self.save()
        }
        else {
            settings = settingsList.first
        }
        
        return settings!
        
    }
    
    func save(settings: Settings) {
        self.save()
    }
    
    private func createSettingsEntity() -> Settings
    {
        let context = self.getManagedObjectContext()
        return Settings(context: context)
    }
}
