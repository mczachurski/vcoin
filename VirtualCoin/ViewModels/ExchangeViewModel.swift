//
//  ExchangeViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 09/05/2021.
//

import Foundation
import VirtualCoinKit

public class ExchangeViewModel: Identifiable, ObservableObject {
    @Published public var price = 0.0
    @Published public var exchangeItem: ExchangeItem
    @Published public var coinViewModel: CoinViewModel
    @Published public var currency: Currency
    
    init(coinViewModel: CoinViewModel, exchangeItem: ExchangeItem, currency: Currency) {
        self.exchangeItem = exchangeItem
        self.coinViewModel = coinViewModel
        self.currency = currency

        self.recalculatePrice()
    }
    
    public func setCoinViewModel(_ coinViewModel: CoinViewModel) {
        self.coinViewModel = coinViewModel
        self.recalculatePrice()
    }
    
    public func setCurrency(_ currency: Currency) {
        self.currency = currency
        self.recalculatePrice()
    }
    
    private func recalculatePrice() {
        // TODO: Recalculate price based on currency.
        self.price = self.coinViewModel.priceUsd * self.exchangeItem.amount
    }
}
