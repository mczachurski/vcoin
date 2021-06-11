//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import CoreData
import Foundation

public extension ExchangeItem {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<ExchangeItem> {
        return NSFetchRequest<ExchangeItem>(entityName: "ExchangeItem")
    }

    @NSManaged var amount: Double
    @NSManaged var coinId: String
    @NSManaged var coinSymbol: String
    @NSManaged var currency: String
}


extension ExchangeItem: Identifiable {
}
