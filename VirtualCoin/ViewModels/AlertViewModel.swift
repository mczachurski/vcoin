//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
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
