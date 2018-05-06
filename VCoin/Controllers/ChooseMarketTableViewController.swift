//
//  ChooseMarketTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit

protocol ChooseMarketDelegate: NSObjectProtocol {
    func chooseMarket(selected: String?)
}

class ChooseMarketTableViewController: BaseTableViewController, UISearchResultsUpdating {

    public var selectedMarket: String?
    public weak var delegate: ChooseMarketDelegate?

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

    // MARK: - Searching

    func updateSearchResults(for searchController: UISearchController) {
        self.filtr = searchController.searchBar.text!
        self.reloadFilteredData()
    }

    private func reloadFilteredData() {
        if self.filtr == "" {
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMarkets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketItem", for: indexPath)

        let market = self.filteredMarkets[indexPath.row]
        cell.textLabel?.text = market.name

        if cell.textLabel?.text == self.selectedMarket {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.delegate?.chooseMarket(selected: cell?.textLabel?.text)

        self.navigationController?.popViewController(animated: true)
    }
}
