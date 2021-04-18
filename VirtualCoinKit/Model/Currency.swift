//
//  Currency.swift
//  vcoin
//
//  Created by Marcin Czachurski on 19.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class Currency {
    public var code: String
    public var locale: String
    public var name: String

    public init(code: String, locale: String, name: String) {
        self.code = code
        self.locale = locale
        self.name = name
    }
}
