//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

public struct CurrencyRate: Decodable {
    public var id: String
    public var symbol: String
    public var currencySymbol: String
    public var type: String
    public var rateUsd: String
}
