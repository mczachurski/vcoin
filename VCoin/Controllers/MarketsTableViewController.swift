//
//  MarketsTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 27.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit

class MarketsTableViewController: BaseTableViewController, UISearchResultsUpdating {
    var coin: Coin!

    private var restClient = RestClient()
    private var markets: [Market] = []
    private var filteredMarkets: [Market] = []
    private var filtr = ""

    // MARK: View loading

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSearchControl(placeholder: "Search markets", searchResultsUpdater: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.markets = []
        for market in Markets.allMarketsList {
            self.markets.append(Market(name: market.name, code: market.code))
        }

        self.filteredMarkets = self.markets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Loading data

    private func loadCoinPrice(market: Market, cell: UITableViewCell, index: Int) {
        self.restClient.loadCoinPrice(symbol: coin.Symbol,
                                      currency: self.settings.currency,
                                      market: market.code) { result in
            switch result {
            case .success(let price):
                if price != nil {
                    market.price = price
                    DispatchQueue.main.async {
                        if cell.tag == index {
                            cell.detailTextLabel?.text = market.price?.toFormattedPrice(currency: self.settings.currency)
                            cell.setNeedsLayout()
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Searching

    func updateSearchResults(for searchController: UISearchController) {
        if let filtr = searchController.searchBar.text {
            self.filtr = filtr
            self.reloadFilteredData()
        }
    }

    private func reloadFilteredData() {
        if self.filtr.isEmpty {
            self.filteredMarkets = self.markets
        } else {
            let uppercasedFilter = self.filtr.uppercased()
            self.filteredMarkets = self.markets.filter {
                $0.code.uppercased().range(of: uppercasedFilter) != nil || $0.name.uppercased().range(of: uppercasedFilter) != nil
            }
        }

        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMarkets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketcell", for: indexPath)
        cell.tag = indexPath.row

        let market = self.filteredMarkets[indexPath.row]
        cell.textLabel?.text = market.name
        cell.detailTextLabel?.text = "-"

        if let price = market.price {
            cell.detailTextLabel?.text = price.toFormattedPrice(currency: self.settings.currency)
        } else {
            self.loadCoinPrice(market: market, cell: cell, index: indexPath.row)
        }

        return cell
    }
}
