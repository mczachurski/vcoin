//
//  SwipeMenuView.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import SwipeMenuViewController

extension SwipeMenuView {
    func setCustomOptions() {
        var options = SwipeMenuViewOptions()
        options.tabView.style = .segmented
        options.tabView.margin = 8.0
        options.tabView.underlineView.backgroundColor = UIColor.main
        options.tabView.backgroundColor = UIColor.clear
        options.tabView.underlineView.height = 1.0
        options.tabView.itemView.textColor = UIColor.gray
        options.tabView.itemView.selectedTextColor = UIColor.main
        options.contentScrollView.backgroundColor = UIColor.black
        
        self.reloadData(options: options)
    }
}
