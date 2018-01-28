//
//  WalletItemTableViewCell.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class WalletItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemBackgroundOutlet: UIView!
    @IBOutlet weak var coinsAmountOutlet: UILabel!
    @IBOutlet weak var coinSymbolOutlet: UILabel!
    @IBOutlet weak var currencyAmountOutlet: UILabel!
    @IBOutlet weak var currencySymbolOutlet: UILabel!
    @IBOutlet weak var marketOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.itemBackgroundOutlet.layer.cornerRadius = 8.0
        self.itemBackgroundOutlet.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
