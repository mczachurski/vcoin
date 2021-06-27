//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

struct WidgetViewModel: Identifiable, Hashable {
    let id: String
    let order: Int32
    let rank: Int
    let symbol: String
    let name: String
    let priceUsd: Double
    let changePercent24Hr: Double
    let price: Double
    var chart: [Double]
}
