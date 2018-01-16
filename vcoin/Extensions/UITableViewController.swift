//
//  UITableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    func removeNavigationBarSeparator() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func removeTableViewCellSeparator() {
        self.tableView.separatorStyle = .none
    }
    
    func addSearchControl(searchResultsUpdater: UISearchResultsUpdating) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = searchResultsUpdater
        
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor.main
        searchController.searchBar.tintColor = UIColor.main
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.darkBackground
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        self.navigationItem.searchController = searchController
    }
    
    func addRefreshControl(target: Any?, action: Selector) {
        self.extendedLayoutIncludesOpaqueBars = true
        
        let refreshControl = UIRefreshControl()
        
        var attributes = [NSAttributedStringKey: AnyObject]()
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        
        refreshControl.tintColor = UIColor.gray
        
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
    }
}
