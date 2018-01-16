//
//  CoinListTableViewCell.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CoinListTableViewCell: UITableViewCell {

    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
