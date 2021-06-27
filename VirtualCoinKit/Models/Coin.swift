//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public struct Coin: Decodable {
    public var id: String
    public var rank: String
    public var symbol: String
    public var name: String
    public var supply: String?
    public var maxSupply: String?
    public var marketCapUsd: String?
    public var volumeUsd24Hr: String?
    public var priceUsd: String?
    public var changePercent24Hr: String?
    public var vwap24Hr: String?
}
