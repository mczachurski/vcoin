//
//  CurrencyRate.swift
//  VirtualCoinKit
//
//  Created by Marcin Czachurski on 12/05/2021.
//

import Foundation

public struct CurrencyRate: Decodable {
    public var id: String
    public var symbol: String
    public var currencySymbol: String
    public var type: String
    public var rateUsd: String
}
