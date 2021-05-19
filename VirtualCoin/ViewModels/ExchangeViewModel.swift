//
//  ExchangeViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 09/05/2021.
//

import Foundation
import VirtualCoinKit

public class ExchangeViewModel: Identifiable, ObservableObject {
    @Published public var priceUsd = 0.0
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
        self.priceUsd = self.coinViewModel.priceUsd * self.exchangeItem.amount
        
        let coinCapClient = CoinCapClient()
        coinCapClient.getCurrencyRate(for: self.currency.id) { result in
            switch result {
            case .success(let currencyRate):
                let currencyRateUsd = Double(currencyRate.rateUsd) ?? 1.0

                DispatchQueue.runOnMain {
                    self.price = self.priceUsd / currencyRateUsd
                }
                break
            case .failure(let error):
                // TODO: Show something in UI.
                print(error)
                break
            }
        }
    }
}
