//
//  ExchangeViewModel.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 09/05/2021.
//

import Foundation
import VirtualCoinKit

public class AlertViewModel: Identifiable, ObservableObject {
    @Published public var alert: Alert
    @Published public var coinViewModel: CoinViewModel
    @Published public var currency: Currency
    
    init(coinViewModel: CoinViewModel, alert: Alert, currency: Currency) {
        self.alert = alert
        self.coinViewModel = coinViewModel
        self.currency = currency
    }
    
    public func setCoinViewModel(_ coinViewModel: CoinViewModel) {
        self.coinViewModel = coinViewModel
    }
    
    public func setCurrency(_ currency: Currency) {
        self.currency = currency
    }
}
