//
//  TodayViewController.swift
//  VCoinWidget
//
//  Created by Marcin Czachurski on 22.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import NotificationCenter
import UIKit
import VCoinKit

class TodayViewController: UITableViewController, NCWidgetProviding {
    private let restClient = RestClient()
    private let settingsHandler = SettingsHandler()
    private let favouritesHandler = FavouritesHandler()

    private let widgetMaxSize = CGFloat(8 * 44)
    private var filteredDataSource: [Coin] = []
    private var settings: Settings!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.settings = self.settingsHandler.getDefaultSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

        self.loadCoinsList()
        completionHandler(NCUpdateResult.newData)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: widgetMaxSize) : maxSize
    }

    // MARK: - Loading data

    private func loadCoinsList() {
        self.restClient.loadCoinsList(callback: { coins in
            self.filteredDataSource = []

            let favourites = self.favouritesHandler.getFavourites()
            if !favourites.isEmpty {
                for favourite in favourites {
                    let favouriteCoin = coins.filter({ coin -> Bool in
                        return coin.Symbol == favourite.coinSymbol
                    })

                    if favouriteCoin.count == 1, let favourite = favouriteCoin.first {
                        self.filteredDataSource.append(favourite)
                    }
                }
            }

            for coin in coins {
                if self.filteredDataSource.count == 8 {
                    break
                }

                let filteredCoin = self.filteredDataSource.filter({ filteredCoin -> Bool in
                    return filteredCoin.Symbol == coin.Symbol
                })

                if filteredCoin.isEmpty {
                    self.filteredDataSource.append(coin)
                }
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, errorCallback: { error in
            print(error)
        })
    }

    private func loadCoinPrice(coin: Coin, cell: CoinListTableViewCell, index: Int) {
        self.restClient.loadCoinPrice(symbol: coin.Symbol, currency: self.settings.currency, callback: { price in
            coin.Price = price
            DispatchQueue.main.async {
                if cell.tag == index {
                    cell.coinPrice = coin.Price
                    cell.setNeedsLayout()
                }
            }
        })
    }

    private func loadCoinChange(coin: Coin, cell: CoinListTableViewCell, index: Int) {
        self.restClient.loadCoinChange(symbol: coin.Symbol, callback: { priceChange in
            coin.ChangePercentagePerDay = priceChange
            DispatchQueue.main.async {
                if cell.tag == index {
                    cell.coinChange = coin.ChangePercentagePerDay
                    cell.setNeedsLayout()
                }
            }
        })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinitem", for: indexPath)
        guard let coinListTableViewCell = cell as? CoinListTableViewCell else {
            return cell
        }

        coinListTableViewCell.tag = indexPath.row

        let coin = self.filteredDataSource[indexPath.row]
        coinListTableViewCell.coinName = coin.FullName
        coinListTableViewCell.currency = self.settings.currency

        if coin.Price == nil {
            coinListTableViewCell.coinChange = nil
            coinListTableViewCell.coinPrice = nil

            self.loadCoinPrice(coin: coin, cell: coinListTableViewCell, index: indexPath.row)
            self.loadCoinChange(coin: coin, cell: coinListTableViewCell, index: indexPath.row)
        } else {
            coinListTableViewCell.coinChange = coin.ChangePercentagePerDay
            coinListTableViewCell.coinPrice = coin.Price
        }

        return coinListTableViewCell
    }
}
