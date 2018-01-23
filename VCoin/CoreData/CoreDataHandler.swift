//
//  CoreDataHandler.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler {
    
    func save()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        
        return persistentContainer.viewContext
    }
}
