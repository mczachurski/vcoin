//
//  PriceAlert.swift
//  VCoinKit
//
//  Created by Marcin Czachurski on 04.02.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public enum Processing {
    case inQueue, processing, finished
}

public class PriceAlert {

    public var currency: String
    public var marketCode: String
    public var coinSymbol: String

    public var price: Double?
    public var processing: Processing

    init(currency: String, markedCode: String, coinSymbol: String) {
        self.currency = currency
        self.marketCode = markedCode
        self.coinSymbol = coinSymbol
        self.processing = Processing.inQueue
    }
}
