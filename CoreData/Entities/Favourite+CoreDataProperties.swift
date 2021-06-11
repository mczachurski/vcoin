//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import CoreData
import Foundation

public extension Favourite {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged var coinId: String
    @NSManaged var order: Int32
}
