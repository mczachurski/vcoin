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
    public func removeNavigationBarSeparator() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    public func removeTableViewCellSeparator() {
        self.tableView.separatorStyle = .none
    }
    
    public func addSearchControl(searchResultsUpdater: UISearchResultsUpdating) {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search currencies"
        searchController.searchBar.barTintColor = UIColor.main
        searchController.searchBar.tintColor = UIColor.main
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    public func addRefreshControl(target: Any?, action: Selector) {
        self.extendedLayoutIncludesOpaqueBars = true
        
        let refreshControl = UIRefreshControl()
        
        var attributes = [NSAttributedStringKey: AnyObject]()
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        
        refreshControl.tintColor = UIColor.gray
        
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    public func unselectSelectedRow() {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
