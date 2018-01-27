//
//  CurrencyTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit

class CurrencyTableViewController: BaseTableViewController, UISearchResultsUpdating {
    
    private var filtr = ""
    private var filteredCurrencies: [Currency] = []
    
    // MARK: View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSearchControl(placeholder: "Search currencies", searchResultsUpdater: self)
        self.filteredCurrencies = Currencies.allCurrenciesList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Searching
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filtr = searchController.searchBar.text!
        self.reloadFilteredData()
    }
    
    private func reloadFilteredData() {
        if self.filtr == "" {
            self.filteredCurrencies = Currencies.allCurrenciesList
        } else {
            let uppercasedFilter = self.filtr.uppercased()
            self.filteredCurrencies = Currencies.allCurrenciesList.filter() {
                $0.code.uppercased().range(of: uppercasedFilter) != nil || $0.name.uppercased().range(of: uppercasedFilter) != nil
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCurrencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyitem", for: indexPath) 
        
        let currency = self.filteredCurrencies[indexPath.row]
        cell.textLabel?.text = currency.code
        cell.detailTextLabel?.text = currency.name
        
        if cell.textLabel?.text == self.settings.currency {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        self.settings.currency = cell?.textLabel?.text
        CoreDataHandler.shared.saveContext()
        
        self.navigationController?.popViewController(animated: true)
    }
}
