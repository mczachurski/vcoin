//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

enum Processing {
    case inQueue, processing, finished
}

class PriceAlert {
    var currency: String
    var coinId: String

    var price: Double?
    var processing: Processing

    init(currency: String, coinId: String) {
        self.currency = currency
        self.coinId = coinId
        self.processing = Processing.inQueue
    }
}
