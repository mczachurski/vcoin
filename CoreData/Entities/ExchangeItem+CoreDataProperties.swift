//
//  ExchangeItem+CoreDataProperties.swift
//  VCoin
//
//  Created by Marcin Czachurski on 12/07/2019.
//  Copyright © 2019 Marcin Czachurski. All rights reserved.
//
//

import CoreData
import Foundation

public extension ExchangeItem {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<ExchangeItem> {
        return NSFetchRequest<ExchangeItem>(entityName: "ExchangeItem")
    }

    @NSManaged var amount: Double
    @NSManaged var coinSymbol: String
    @NSManaged var currency: String
    @NSManaged var marketCode: String
}


extension ExchangeItem: Identifiable {
}
