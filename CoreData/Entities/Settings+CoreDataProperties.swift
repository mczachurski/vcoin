//
//  Settings+CoreDataProperties.swift
//  VCoin
//
//  Created by Marcin Czachurski on 12/07/2019.
//  Copyright © 2019 Marcin Czachurski. All rights reserved.
//
//

import CoreData
import Foundation

public extension Settings {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged var currency: String
    @NSManaged var isDarkMode: Bool
}
