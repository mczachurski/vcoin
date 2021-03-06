//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public struct Market: Decodable {    
    public var exchangeId: String
    public var baseId: String?
    public var quoteId: String?
    public var baseSymbol: String?
    public var quoteSymbol: String?
    public var volumeUsd24Hr: String?
    public var priceUsd: String?
    public var volumePercent: String?
}
