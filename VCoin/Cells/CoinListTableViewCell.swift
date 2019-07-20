//
//  CoinListTableViewCell.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CoinListTableViewCell: UITableViewCell {
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var coinPriceLabel: UILabel!
    @IBOutlet private weak var coinChangeLabel: UILabel!
    @IBOutlet private weak var coinFavouriteImage: UIImageView!

    var currency: String?

    var coinName: String? {
        didSet {
            self.coinNameLabel?.text = self.coinName
        }
    }

    var coinPrice: Double? {
        didSet {
            self.coinPriceLabel.text = self.coinPrice?.toFormattedPrice(currency: self.currency ?? "?") ?? "-"
        }
    }

    var coinChange: Double? {
        didSet {
            self.coinChangeLabel?.text = self.coinChange?.toFormattedPercent() ?? "-"

            if self.coinChange ?? 0 > 0 {
                self.coinPriceLabel?.textColor = UIColor.greenPastel
            } else {
                self.coinPriceLabel?.textColor = UIColor.redPastel
            }
        }
    }

    var isDarkMode: Bool? {
        didSet {
            if isDarkMode ?? true {
                self.coinNameLabel.textColor = UIColor.white
            } else {
                self.coinNameLabel.textColor = UIColor.black
            }
        }
    }

    var isFavourite: Bool? {
        didSet {
            if isFavourite ?? true {
                self.coinFavouriteImage.isHidden = false
            } else {
                self.coinFavouriteImage.isHidden = true
            }
        }
    }
}
