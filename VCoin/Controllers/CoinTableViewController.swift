//
//  CoinTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 06.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit
import HGPlaceholders
import Reachability

class CoinTableViewController: BaseTableViewController, UISearchResultsUpdating, PlaceholderDelegate {

    private var coinsDataSource: [Coin] = [] {
        didSet {
            self.reloadFilteredData()
        }
    }

    private var baseTableView: BaseTableView {
        return self.tableView as! BaseTableView // swiftlint:disable:this force_cast
    }

    private var filteredDataSource: [Coin] = []
    private var favouritesHandler = FavouritesHandler()
    private var restClient = RestClient()
    private var reachability = Reachability()
    private var filtr = ""
    private var currentCurrency: String!

    // MARK: - View loading

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSearchControl(placeholder: "Search currencies", searchResultsUpdater: self)
        self.addRefreshControl(target: self, action: #selector(refreshTableView))

        self.baseTableView.placeholderDelegate = self
        self.baseTableView.tintColor = UIColor.main
        self.baseTableView.showLoadingPlaceholder()
        self.loadCoinsList()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.reloadRows(at: [selectedRowIndexPath], with: .none)
        }

        super.viewWillAppear(animated)
        self.reloadSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func reloadSettings() {
        self.settings = self.settingsHandler.getDefaultSettings()

        if self.currentCurrency != nil && self.currentCurrency != self.settings.currency {
            self.clearCoinPrices()
            self.reloadFilteredData()
        }

        self.currentCurrency = self.settings?.currency
    }

    private func clearCoinPrices() {
        for coin in self.coinsDataSource {
            coin.Price = nil
        }
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
            self.filteredDataSource = self.coinsDataSource.filter { $0.FullName?.uppercased().range(of: uppercasedFilter) != nil }
        }

        self.tableView.reloadData()
    }

    // MARK: - Refreshing

    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        if placeholder.key == PlaceholderKey.loadingKey {
            self.coinsDataSource = []
            self.baseTableView.showNoResultsPlaceholder()
        } else {
            self.baseTableView.showLoadingPlaceholder()
            self.loadCoinsList()
        }
    }

    @objc func refreshTableView(refreshControl: UIRefreshControl) {
        self.loadCoinsList()
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
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl?.endRefreshing()
                }
            }
        }, errorCallback: {(_) in
            DispatchQueue.main.async {
                self.baseTableView.showErrorPlaceholder()
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl?.endRefreshing()
                }
            }
        })
    }

    private func loadCoinPrice(coin: Coin, cell: CoinListTableViewCell, index: Int) {
        self.restClient.loadCoinPrice(symbol: coin.Symbol, currency: self.settings.currency!) { (price) in
            coin.Price = price
            DispatchQueue.main.async {
                if cell.tag == index {
                    cell.coinPrice = coin.Price
                    cell.setNeedsLayout()
                }
            }
        }
    }

    private func loadCoinChange(coin: Coin, cell: CoinListTableViewCell, index: Int) {

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "coinitem", for: indexPath)
        guard let coinListTableViewCell = cell as? CoinListTableViewCell else {
            return cell
        }

        coinListTableViewCell.tag = indexPath.row
        coinListTableViewCell.isDarkMode = self.settings.isDarkMode

        let coin = self.filteredDataSource[indexPath.row]
        coinListTableViewCell.coinName = coin.FullName
        coinListTableViewCell.currency = self.settings.currency
        coinListTableViewCell.isFavourite = favouritesHandler.isFavourite(symbol: coin.Symbol)

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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coindetails" {
            if let destination = segue.destination as? CoinViewController {
                if let selectedPath = self.tableView.indexPathForSelectedRow {
                    destination.coin = self.filteredDataSource[selectedPath.row]
                    destination.settings = self.settings
                }
            }
        }
    }
}
