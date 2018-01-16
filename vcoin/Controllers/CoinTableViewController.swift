//
//  CoinTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 06.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CoinTableViewController: UITableViewController, UISearchResultsUpdating {

    private var coinsDataSource: [Coin] = []
    private var filteredDataSource: [Coin] = []
    private var lastLoadedPriceIndex = -1
    private var filtr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.addSearchControl()
        self.addRefreshControl()
        
        self.removeTableViewCellSeparator()
        self.removeNavigationBarSeparator()
        
        self.loadCoinsList()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    private func removeNavigationBarSeparator() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    private func removeTableViewCellSeparator() {
        self.tableView.separatorStyle = .none
    }
    
    private func addSearchControl() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor.main
        searchController.searchBar.tintColor = UIColor.main
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        self.navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filtr = searchController.searchBar.text!
        self.reloadData()
    }
    
    private func reloadData() {
        if self.filtr == "" {
            self.filteredDataSource = self.coinsDataSource
        } else {
            self.filteredDataSource = self.coinsDataSource.filter() { $0.FullName?.range(of: self.filtr) != nil }
        }
        
        self.tableView.reloadData()
    }
    
    private func addRefreshControl() {
        self.extendedLayoutIncludesOpaqueBars = true
        
        let refreshControl = UIRefreshControl()
        
        var attributes = [NSAttributedStringKey: AnyObject]()
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        
        refreshControl.tintColor = UIColor.gray
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refreshTableView(refreshControl: UIRefreshControl) {
        self.loadCoinsList()
    }
    
    private func loadCoinsList() {
        self.lastLoadedPriceIndex = -1
        
        let request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/all/coinlist")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    if let coinsDict = json["Data"] as? [String:Any] {
                        
                        var downloadedCoins:[Coin] = []
                        for (_, data) in coinsDict {
                            if let coinData = data as? [String:Any] {
                                let coin = Coin(data: coinData)
                                downloadedCoins.append(coin)
                            }
                        }
                        
                        downloadedCoins.sort {
                            let coin1Sort = Int($0.SortOrder!)
                            let coin2Sort = Int($1.SortOrder!)
                            return coin1Sort! < coin2Sort!
                        }
                        
                        DispatchQueue.main.async {
                            self.coinsDataSource = downloadedCoins
                            self.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }
                }
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    private func loadCoinPrice(coin:Coin, cell: CoinListTableViewCell, index: Int) {
        
        let priceRequest = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(coin.Symbol)&tsyms=USD&e=CCCAGG")!)
        
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, response, error -> Void in
            do {
                if let priceJson = try JSONSerialization.jsonObject(with: priceData!, options: []) as? [String:Double] {
                    coin.Price = priceJson["USD"]

                    DispatchQueue.main.async {
                        if cell.tag == index {
                            cell.coinPrice?.text = coin.Price?.toFormattedPrice() ?? "-"
                            cell.setNeedsLayout()
                        }
                    }
                }
            } catch {
                print("error")
            }
            
        })
        
        priceTask.resume()
    }
    
    private func loadCoinChange(coin:Coin, cell: CoinListTableViewCell, index: Int) {
        
        let priceRequest = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=\(coin.Symbol)&tsym=USD&e=CCCAGG")!)
        
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, response, error -> Void in
            do {
                if let priceJson = try JSONSerialization.jsonObject(with: priceData!, options: []) as? [String:Any] {
                    if let priceData = priceJson["RAW"] as? [String:Any] {
                        if let changePercantage = priceData["CHANGEPCT24HOUR"] as? Double {
                            coin.ChangePercentagePerDay = changePercantage
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if cell.tag == index {
                            cell.coinChange?.text = coin.ChangePercentagePerDay?.toFormattedPercent() ?? "-"
                            
                            if coin.ChangePercentagePerDay ?? 0 > 0 {
                                cell.coinPrice?.textColor = UIColor.greenPastel
                            }
                            else {
                                cell.coinPrice?.textColor = UIColor.redPastel
                            }
                            
                            cell.setNeedsLayout()
                        }
                    }
                }
            } catch {
                print("error")
            }
            
        })
        
        priceTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        // Configure the cell.
        let coin = self.filteredDataSource[indexPath.row]
        cell.coinName?.text = coin.FullName
        
        if coin.Price == nil {
            cell.coinChange?.text = "-"
            cell.coinPrice?.text = "-"
            cell.coinPrice?.textColor = UIColor.redPastel
            
            self.loadCoinPrice(coin: coin, cell: cell, index: indexPath.row)
            self.loadCoinChange(coin: coin, cell: cell, index: indexPath.row)
        }
        else {
            cell.coinChange?.text = coin.ChangePercentagePerDay?.toFormattedPercent() ?? "-"
            cell.coinPrice?.text = coin.Price?.toFormattedPrice() ?? "-"
            cell.coinPrice?.textColor = UIColor.redPastel
            
            if coin.ChangePercentagePerDay ?? 0 > 0 {
                cell.coinPrice?.textColor = UIColor.greenPastel
            }
            else {
                cell.coinPrice?.textColor = UIColor.redPastel
            }
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
