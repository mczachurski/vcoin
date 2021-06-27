//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public struct Currency {
    public var id: String
    public var symbol: String
    public var locale: String
    public var name: String

    public init(id: String = "", symbol: String = "", locale: String = "", name: String = "") {
        self.id = id
        self.symbol = symbol
        self.locale = locale
        self.name = name
    }
}

extension Currency: Hashable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.symbol == rhs.symbol
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.symbol)
    }
}

extension Currency: Identifiable {
}
