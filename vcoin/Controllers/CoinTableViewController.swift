//
//  CoinTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 06.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CoinTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var coinsDataSource: [Coin] = [] {
        didSet {
            self.reloadFilteredData()
        }
    }
    
    private var filteredDataSource: [Coin] = []
    
    private var filtr = ""
    private var restClient = RestClient()
    
    // MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.addSearchControl(searchResultsUpdater: self)
        self.addRefreshControl(target: self, action: #selector(refreshTableView))
        
        self.removeTableViewCellSeparator()
        self.removeNavigationBarSeparator()
        
        self.loadCoinsList()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
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
            self.filteredDataSource = self.coinsDataSource.filter() { $0.FullName?.range(of: self.filtr) != nil }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Refreshing
        
    @objc func refreshTableView(refreshControl: UIRefreshControl) {
        self.loadCoinsList()
    }
    
    // MARK: - Loading data
    
    private func loadCoinsList() {
        self.restClient.loadCoinsList { (coins) in
            DispatchQueue.main.async {
                self.coinsDataSource = coins
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func loadCoinPrice(coin:Coin, cell: CoinListTableViewCell, index: Int) {
        self.restClient.loadCoinPrice(symbol: coin.Symbol) { (price) in
            coin.Price = price
            DispatchQueue.main.async {
                if cell.tag == index {
                    cell.coinPrice = coin.Price
                    cell.setNeedsLayout()
                }
            }
        }
    }
    
    private func loadCoinChange(coin:Coin, cell: CoinListTableViewCell, index: Int) {
        
        self.restClient.loadCoinChange(symbol: coin.Symbol) { (priceChange) in
            coin.ChangePercentagePerDay = priceChange
            DispatchQueue.main.async {
                if cell.tag == index {
                    cell.coinChange = coin.ChangePercentagePerDay
                    cell.setNeedsLayout()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinitem", for: indexPath) as! CoinListTableViewCell
        cell.tag = indexPath.row
        
        let coin = self.filteredDataSource[indexPath.row]
        cell.coinName = coin.FullName
        
        if coin.Price == nil {
            cell.coinChange = nil
            cell.coinPrice = nil
            
            self.loadCoinPrice(coin: coin, cell: cell, index: indexPath.row)
            self.loadCoinChange(coin: coin, cell: cell, index: indexPath.row)
        }
        else {
            cell.coinChange = coin.ChangePercentagePerDay
            cell.coinPrice = coin.Price
        }
        
        // Configure selection.
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 20.0 / 255.0, green: 20.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coindetails" {
            if let destination = segue.destination as? CoinViewController {
                if let selectedPath = self.tableView.indexPathForSelectedRow {
                    destination.coin = self.filteredDataSource[selectedPath.row]
                }
            }
        }
    }
}
