//
//  CurrencyTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {

    var settings: Settings!
    var settingsHandler = SettingsHandler()
    
    // MARK: View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.removeNavigationBarSeparator()
        self.removeTableViewCellSeparator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.unselectSelectedRow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrencyLocale.allCurrenciesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyitem", for: indexPath) 
        
        let currency = CurrencyLocale.allCurrenciesList[indexPath.row]
        cell.textLabel?.text = currency.code
        cell.detailTextLabel?.text = currency.name
        
        if cell.textLabel?.text == self.settings.currency {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.setSelectedColor(color: UIColor.darkBackground)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        self.settings.currency = cell?.textLabel?.text
        self.settingsHandler.save(settings: self.settings)
        
        self.navigationController?.popViewController(animated: true)
    }
}
