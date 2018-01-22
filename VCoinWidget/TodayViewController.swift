//
//  TodayViewController.swift
//  VCoinWidget
//
//  Created by Marcin Czachurski on 22.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import NotificationCenter
import VCoinKit

class TodayViewController: UITableViewController, NCWidgetProviding {
    
    private let restClient = RestClient()
    private let widgetMaxSize = CGFloat(8 * 44)
    private var filteredDataSource: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.removeTableViewCellSeparator()
        
        self.loadCoinsList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: widgetMaxSize) : maxSize
    }
    
    // MARK: - Loading data
    
    private func loadCoinsList() {
        self.restClient.loadCoinsList { (coins) in
            DispatchQueue.main.async {
                
                for (index, coin) in coins.enumerated() {
                    self.filteredDataSource.append(coin)
                    
                    if index == 7 {
                        break
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadCoinPrice(coin:Coin, cell: CoinListTableViewCell, index: Int) {
        self.restClient.loadCoinPrice(symbol: coin.Symbol, currency: "USD") { (price) in
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
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinitem", for: indexPath) as! CoinListTableViewCell
        cell.tag = indexPath.row
        
        let coin = self.filteredDataSource[indexPath.row]
        cell.coinName = coin.FullName
        cell.currency = "USD"
        
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
        
        return cell
    }
}
