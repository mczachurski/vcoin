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
        bgColorView.backgroundColor = color
        self.selectedBackgroundView = bgColorView
    }
}
