//
//  CoinListTableViewCell.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CoinListTableViewCell: UITableViewCell {

    @IBOutlet weak private var coinNameLabel: UILabel!
    @IBOutlet weak private var coinPriceLabel: UILabel!
    @IBOutlet weak private var coinChangeLabel: UILabel!

    public var coinName:String? {
        didSet {
            self.coinNameLabel?.text = self.coinName
        }
    }
    
    public var coinPrice: Double? {
        didSet {
            self.coinPriceLabel?.text = self.coinPrice?.toFormattedPrice() ?? "-"
        }
    }
    
    public var coinChange: Double? {
        didSet {
            self.coinChangeLabel?.text = self.coinChange?.toFormattedPercent() ?? "-"
            
            if self.coinChange ?? 0 > 0 {
                self.coinPriceLabel?.textColor = UIColor.greenPastel
            }
            else {
                self.coinPriceLabel?.textColor = UIColor.redPastel
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
