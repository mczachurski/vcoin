//
//  PriceAlert.swift
//  VCoinKit
//
//  Created by Marcin Czachurski on 04.02.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
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
