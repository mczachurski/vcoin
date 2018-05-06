//
//  ExchangeItemTableViewCell.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit

class ExchangeItemTableViewCell: UITableViewCell {

    public var exchangeItem: ExchangeItem! {
        didSet {
            self.coinSymbolOutlet.text = self.exchangeItem.coinSymbol
            self.coinsAmountOutlet.text = String(self.exchangeItem.amount)
            self.currencyAmountOutlet.text = "..."
            self.currencySymbolOutlet.text = self.exchangeItem.currency
            self.marketOutlet.text = self.exchangeItem.marketCode
            reloadPrice()
        }
    }

    public var isDarkMode: Bool? {
        didSet {
            if isDarkMode ?? true {
                self.coinsAmountOutlet.textColor = UIColor.white
                self.currencyAmountOutlet.textColor = UIColor.white
                self.imageOutlet.image = UIImage(named: "exchange-white")
            } else {
                self.coinsAmountOutlet.textColor = UIColor.black
                self.currencyAmountOutlet.textColor = UIColor.black
                self.imageOutlet.image = UIImage(named: "exchange-black")
            }
        }
    }

    @IBOutlet private weak var coinsAmountOutlet: UILabel!
    @IBOutlet private weak var coinSymbolOutlet: UILabel!
    @IBOutlet private weak var currencyAmountOutlet: UILabel!
    @IBOutlet private weak var currencySymbolOutlet: UILabel!
    @IBOutlet private weak var marketOutlet: UILabel!
    @IBOutlet private weak var imageOutlet: UIImageView!

    private var restClient = RestClient()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func reloadPrice() {
        restClient.loadCoinPrice(symbol: self.exchangeItem.coinSymbol!, currency: self.exchangeItem.currency!,
                                 market: self.exchangeItem.marketCode!) { (value) in
            if value != nil {
                let price = value! * self.exchangeItem.amount
                DispatchQueue.main.async {
                    self.currencyAmountOutlet.text = price.toFormattedPrice(currency: self.exchangeItem.currency!, maximumFractionDigits: 2)
                }
            } else {
                DispatchQueue.main.async {
                    self.currencyAmountOutlet.text = "-"
                }
            }
        }
    }
}
