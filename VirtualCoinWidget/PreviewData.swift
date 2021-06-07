//
//  PreviewData.swift
//  VirtualCoinWidgetExtension
//
//  Created by Marcin Czachurski on 07/06/2021.
//

import Foundation

struct PreviewData {
    
    static func getWidgetViewModels() -> [WidgetViewModel] {
        return [
            WidgetViewModel(id: "bitcoin",
                            rank: 1,
                            symbol: "BTC",
                            name: "Bitcoin",
                            priceUsd: 36135.11,
                            changePercent24Hr: -4.72,
                            price: 36135.11,
                            chart: getChartData()),
            
            WidgetViewModel(id: "ethereum",
                            rank: 2,
                            symbol: "ETH",
                            name: "Ethereum",
                            priceUsd: 2662.72,
                            changePercent24Hr: -4.43,
                            price: 2662.72,
                            chart: getChartData()),

            WidgetViewModel(id: "dogecoin",
                            rank: 3,
                            symbol: "DOGE",
                            name: "Dogecoin",
                            priceUsd: 0.37526429,
                            changePercent24Hr: -5.18,
                            price: 0.37526429,
                            chart: getChartData()),

            WidgetViewModel(id: "cardano",
                            rank: 4,
                            symbol: "USDT",
                            name: "Cardano",
                            priceUsd: 1.69,
                            changePercent24Hr: -5.18,
                            price: 1.69,
                            chart: getChartData()),

            WidgetViewModel(id: "tether",
                            rank: 5,
                            symbol: "USDT",
                            name: "Tether",
                            priceUsd: 1.00,
                            changePercent24Hr: 0.03,
                            price: 1.00,
                            chart: getChartData()),

            WidgetViewModel(id: "xrp",
                            rank: 6,
                            symbol: "XRP",
                            name: "XRP",
                            priceUsd: 0.94153174,
                            changePercent24Hr: -5.35,
                            price: 0.94153174,
                            chart: getChartData())
        ]
    }
    
    private static func getChartData() -> [Double] {
        return [34, 34, 23, 34, 45, 65, 34, 32, 23, 33, 65, 57, 65, 34, 65, 67]
    }
}
