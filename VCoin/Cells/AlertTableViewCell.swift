//
//  AlertTableViewCell.swift
//  VCoin
//
//  Created by Marcin Czachurski on 01.02.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    public var alert: Alert! {
        didSet {
            self.coinSymbolOutlet.text = self.alert.coinSymbol
            self.priceOutlet.text = self.alert.price.toFormattedPrice(currency: self.alert.currency!)
            self.marketNameOutlet.text = self.alert.marketCode
            self.isEnabledOutlet.isOn = self.alert.isEnabled
        }
    }
    
    public var isDarkMode: Bool? {
        didSet {
            if isDarkMode ?? true {
                self.coinSymbolOutlet.textColor = UIColor.white
                self.priceOutlet.textColor = UIColor.white
                self.marketNameOutlet.textColor = UIColor.white
            }
            else {
                self.coinSymbolOutlet.textColor = UIColor.black
                self.priceOutlet.textColor = UIColor.black
                self.marketNameOutlet.textColor = UIColor.black
            }
        }
    }
    
    @IBOutlet weak var coinSymbolOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var marketNameOutlet: UILabel!
    @IBOutlet weak var isEnabledOutlet: UISwitch!
    
    
    @IBAction func isEnabledChangedAction(_ sender: UISwitch) {
        self.alert.isEnabled = sender.isOn
        CoreDataHandler.shared.saveContext()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
