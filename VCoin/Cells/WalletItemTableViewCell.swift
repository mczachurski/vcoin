//
//  WalletItemTableViewCell.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit

class WalletItemTableViewCell: UITableViewCell {

    public var walletItem: WalletItem! {
        didSet {
            self.coinSymbolOutlet.text = self.walletItem.coinSymbol
            self.coinsAmountOutlet.text = String(self.walletItem.amount)
            self.currencyAmountOutlet.text = "..."
            self.currencySymbolOutlet.text = self.walletItem.currency
            self.marketOutlet.text = self.walletItem.marketCode
            reloadPrice()
        }
    }
    
    public var customBacgroundColor: UIColor! {
        didSet {
            self.itemBackgroundOutlet.backgroundColor = self.customBacgroundColor
            self.itemBackgroundOutlet.layer.shadowColor = self.customBacgroundColor.cgColor
            self.itemBackgroundOutlet.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.itemBackgroundOutlet.layer.shadowOpacity = 0.3
            self.itemBackgroundOutlet.layer.shadowRadius = 3
        }
    }
    
    @IBOutlet private weak var itemBackgroundOutlet: UIView!
    @IBOutlet private weak var coinsAmountOutlet: UILabel!
    @IBOutlet private weak var coinSymbolOutlet: UILabel!
    @IBOutlet private weak var currencyAmountOutlet: UILabel!
    @IBOutlet private weak var currencySymbolOutlet: UILabel!
    @IBOutlet private weak var marketOutlet: UILabel!
    
    private var restClient = RestClient()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.itemBackgroundOutlet.layer.cornerRadius = 12.0
        self.itemBackgroundOutlet.clipsToBounds = false
        
        /*
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 12.0
        gradientLayer.frame.size = self.itemBackgroundOutlet.frame.size
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.main.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.itemBackgroundOutlet.layer.insertSublayer(gradientLayer, at: 0)
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func reloadPrice() {
        restClient.loadCoinPrice(symbol: self.walletItem.coinSymbol!, currency: self.walletItem.currency!, market: self.walletItem.marketCode!) { (value) in
            if value != nil {
                let price = value! * self.walletItem.amount
                DispatchQueue.main.async {
                    self.currencyAmountOutlet.text = price.toFormattedPrice(currency: self.walletItem.currency!, maximumFractionDigits: 2)
                }
            }
            else {
                DispatchQueue.main.async {
                    self.currencyAmountOutlet.text = "-"
                }
            }
        }
    }
}
