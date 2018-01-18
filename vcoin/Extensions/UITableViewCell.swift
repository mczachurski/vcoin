//
//  UITableViewCell.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    func setSelectedColor(color: UIColor) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 20.0 / 255.0, green: 20.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
        self.selectedBackgroundView = bgColorView
    }
}
