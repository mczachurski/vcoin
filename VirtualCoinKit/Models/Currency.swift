//
//  Currency.swift
//  vcoin
//
//  Created by Marcin Czachurski on 19.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public struct Currency {
    public var id: String
    public var locale: String
    public var name: String

    public init(id: String, locale: String, name: String) {
        self.id = id
        self.locale = locale
        self.name = name
    }
}

extension Currency: Hashable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Currency: Identifiable {
}
