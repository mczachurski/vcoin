//
//  CoinViewModel.swift
//  VirtualCoinWidgetExtension
//
//  Created by Marcin Czachurski on 07/06/2021.
//

import Foundation

struct WidgetViewModel: Identifiable, Hashable {
    let id: String
    let rank: Int
    let symbol: String
    let name: String
    let priceUsd: Double
    let changePercent24Hr: Double
    let price: Double
    let chart: [Double]
}
