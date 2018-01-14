//
//  CoinTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 06.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CoinTableViewController: UITableViewController {

    private var coinsDataSource: [Coin] = []
    private var lastLoadedPriceIndex = -1
    
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
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func removeTableViewCellSeparator() {
        self.tableView.separatorStyle = .none
    }
    
    private func addSearchControl() {
        //let sc = UISearchController(searchResultsController: nil)
        //self.navigationItem.searchController = sc
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
                        
                        self.loadCoinsPrices(coins: downloadedCoins, startIndex: 0)
                    }
                }
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    private func loadCoinsPrices(coins:[Coin], startIndex:Int) {
        
        if startIndex <= self.lastLoadedPriceIndex {
            return
        }
        
        var coinsSymbols = ""
        for index in startIndex...startIndex + 49 {
            if index >= coins.count {
                break
            }
            
            coinsSymbols = coinsSymbols + coins[index].Symbol! + ","
        }
        
        self.lastLoadedPriceIndex = startIndex + 49
        
        let priceRequest = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(coinsSymbols)&tsyms=USD")!)
        
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, response, error -> Void in
            do {
                if let priceJson = try JSONSerialization.jsonObject(with: priceData!, options: []) as? [String:Any] {
                    for coin in coins {
                        if let priceList = priceJson[coin.Symbol!] as? [String:Float] {
                            coin.Price = priceList["USD"]
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.coinsDataSource = coins
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
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
        return self.coinsDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinitem", for: indexPath)

        // Configure the cell.
        let coin = self.coinsDataSource[indexPath.row]
        cell.textLabel?.text = coin.FullName
        
        if coin.Price == nil {
            cell.detailTextLabel?.text = "-"
            loadCoinsPrices(coins: self.coinsDataSource, startIndex: indexPath.row)
        }
        else {
            cell.detailTextLabel?.text = coin.Price?.toFormattedPrice()
        }
        
        // Configure selection.
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 20.0 / 255.0, green: 20.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        if coin.Price == nil {
            
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coindetails" {
            if let destination = segue.destination as? CoinViewController {
                if let selectedPath = self.tableView.indexPathForSelectedRow {
                    destination.coin = self.coinsDataSource[selectedPath.row]
                }
            }
        }
    }
}
