//
//  CoinTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 06.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import HandyJSON

class CoinTableViewController: UITableViewController {

    private var coins: [Coin] = []
    private var lastLoadedPriceIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let sc = UISearchController(searchResultsController: nil)
        //self.navigationItem.searchController = sc
        
        // Remove cell separator.
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.clearsSelectionOnViewWillAppear = false
        loadCoinsList()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    fileprivate func loadCoinsPrices(startIndex:Int) {
        
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
                    for coin in self.coins {
                        if let priceList = priceJson[coin.Symbol!] as? [String:Float] {
                            coin.Price = priceList["USD"]
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("error")
            }
            
        })
        
        priceTask.resume()
    }
    
    private func loadCoinsList() {
        let request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/all/coinlist")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    if let coinsDict = json["Data"] as? [String:Any] {
                        for (_, data) in coinsDict {
                            if let coinData = data as? [String:Any] {
                                let coin = Coin(data: coinData)
                                self.coins.append(coin)
                            }
                        }
                        
                        self.coins.sort {
                            let coin1Sort = Int($0.SortOrder!)
                            let coin2Sort = Int($1.SortOrder!)
                            return coin1Sort! < coin2Sort!
                        }
                        
                        self.loadCoinsPrices(startIndex: 0)
                    }
                }
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinitem", for: indexPath)

        // Configure the cell.
        let coin = coins[indexPath.row]
        cell.textLabel?.text = coin.FullName
        
        if coin.Price == nil {
            cell.detailTextLabel?.text = "-"
            loadCoinsPrices(startIndex: indexPath.row)
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
                    destination.coin = self.coins[selectedPath.row]
                }
            }
        }
    }
}
