//
//  UITableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

public extension UITableViewController {
    func removeNavigationBarSeparator() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    func addSearchControl(placeholder: String, searchResultsUpdater: UISearchResultsUpdating) {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholder
        searchController.searchBar.barTintColor = UIColor.main
        searchController.searchBar.tintColor = UIColor.main
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func addRefreshControl(target: Any?, action: Selector) {
        self.extendedLayoutIncludesOpaqueBars = true

        let refreshControl = UIRefreshControl()

        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)

        refreshControl.tintColor = UIColor.gray

        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
    }

    func unselectSelectedRow() {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
