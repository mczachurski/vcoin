//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import CoreData
import Foundation

public extension Alert {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Alert> {
        return NSFetchRequest<Alert>(entityName: "Alert")
    }

    @NSManaged var alertSentDate: Date?
    @NSManaged var coinId: String
    @NSManaged var coinSymbol: String
    @NSManaged var currency: String
    @NSManaged var isEnabled: Bool
    @NSManaged var isPriceLower: Bool
    @NSManaged var price: Double
}
