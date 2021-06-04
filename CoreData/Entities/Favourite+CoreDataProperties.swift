//
//  Favourite+CoreDataProperties.swift
//  VCoin
//
//  Created by Marcin Czachurski on 12/07/2019.
//  Copyright © 2019 Marcin Czachurski. All rights reserved.
//
//

import CoreData
import Foundation

public extension Favourite {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged var coinId: String
}
