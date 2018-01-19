//
//  BaseTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 19.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController : UITableViewController {

    var settingsHandler = SettingsHandler()
    var settings:Settings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.removeTableViewCellSeparator()
        self.removeNavigationBarSeparator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unselectSelectedRow()
        
        self.settings = self.settingsHandler.getDefaultSettings()
        self.settings.isDarkMode ? enableDarkMode() : disableDarkMode()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        enableDarkMode()
        self.tableView.reloadData()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        disableDarkMode()
        self.tableView.reloadData()
    }
    
    open func enableDarkMode() {
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    open func disableDarkMode() {
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.settings.isDarkMode {
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.black
            
            cell.setSelectedColor(color: UIColor.darkBackground)
        }
        else {
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            
            cell.setSelectedColor(color: UIColor.lightBackground)
        }
    }
}
