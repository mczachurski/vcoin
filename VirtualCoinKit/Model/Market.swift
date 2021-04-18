//
//  Market.swift
//  VCoinKit
//
//  Created by Marcin Czachurski on 27.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class Market {
    public var name: String
    public var code: String
    public var price: Double?

    public init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
