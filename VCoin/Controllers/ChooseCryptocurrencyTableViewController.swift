//
//  ChooseCryptocurrencyTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit
import Reachability
import HGPlaceholders

protocol ChooseCryptocurrencyDelegate : NSObjectProtocol {
    func chooseCryptocurrency(selected: String?)
}

class ChooseCryptocurrencyTableViewController: BaseTableViewController, UISearchResultsUpdating, PlaceholderDelegate {

    public var selectedCryptocurrency: String?
    public weak var delegate: ChooseCryptocurrencyDelegate?
    
    private var coinsDataSource: [Coin] = [] {
        didSet {
            self.reloadFilteredData()
        }
    }
    
    private var baseTableView:BaseTableView {
        get {
            return self.tableView as! BaseTableView
        }
    }
    
    private var filteredDataSource: [Coin] = []
    private var restClient = RestClient()
    private var reachability = Reachability()
    private var filtr = ""
    private var currentCurrency:String!
    
    // MARK: View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSearchControl(placeholder: "Search currencies", searchResultsUpdater: self)
        
        self.baseTableView.placeholderDelegate = self
        self.baseTableView.tintColor = UIColor.main
        self.baseTableView.showLoadingPlaceholder()
        self.loadCoinsList()
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
            self.filteredDataSource = self.coinsDataSource
        } else {
            let uppercasedFilter = self.filtr.uppercased()
            self.filteredDataSource = self.coinsDataSource.filter() { $0.FullName?.uppercased().range(of: uppercasedFilter) != nil }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Refreshing
    
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        if placeholder.key == PlaceholderKey.loadingKey {
            self.coinsDataSource = []
            self.baseTableView.showNoResultsPlaceholder()
        }
        else {
            self.baseTableView.showLoadingPlaceholder()
            self.loadCoinsList()
        }
    }
    
    // MARK: - Loading data
    
    private func loadCoinsList() {
        
        if reachability?.connection == Reachability.Connection.none {
            self.baseTableView.showNoConnectionPlaceholder()
            return
        }
        
        self.restClient.loadCoinsList(callback: { (coins) in
            DispatchQueue.main.async {
                self.coinsDataSource = coins
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.baseTableView.showErrorPlaceholder()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoItem", for: indexPath)

        let coin = self.filteredDataSource[indexPath.row]
        cell.textLabel?.text = coin.Name
        cell.detailTextLabel?.text = coin.CoinName
        
        if cell.textLabel?.text == self.selectedCryptocurrency {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.delegate?.chooseCryptocurrency(selected: cell?.textLabel?.text)
        
        self.navigationController?.popViewController(animated: true)
    }
}
