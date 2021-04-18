//
//  Coin.swift
//  vcoin
//
//  Created by Marcin Czachurski on 06.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class Coin: Identifiable {
    public var id: String?
    public var algorithm: String?
    public var coinName: String?
    public var fullName: String?
    public var fullyPremined: String?
    public var imageUrl: String?
    public var name: String?
    public var preMinedValue: String?
    public var proofType: String?
    public var sortOrder: String?
    public var sponsored: Bool?
    public var symbol: String = ""
    public var totalCoinSupply: String?
    public var totalCoinsFreeFloat: String?
    public var url: String?
    public var price: Double?
    public var changePercentagePerDay: Double?

    public init(data: [String: Any]) {
        if let symbol = data["Symbol"] as? String {
            self.symbol = symbol
        }

        self.id = data["Id"] as? String
        self.fullName = data["FullName"] as? String
        self.url = data["Url"] as? String
        self.imageUrl = data["ImageUrl"] as? String
        self.name = data["Name"] as? String
        self.sortOrder = data["SortOrder"] as? String
        self.coinName = data["CoinName"] as? String
    }
}
