//
//  ExchangesTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import HGPlaceholders
import UIKit

class ExchangesTableViewController: BaseTableViewController, ExchangeItemChangedDelegate, PlaceholderDelegate {
    private var exchangeItemsHandler = ExchangeItemsHandler()
    private var exchangeItems: [ExchangeItem] = []

    private var baseTableView: BaseTableView {
        return self.tableView as! BaseTableView // swiftlint:disable:this force_cast
    }

    // MARK: - View loading

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addRefreshControl(target: self, action: #selector(refreshTableView))

        let placeholder = customPlaceholder()
        self.baseTableView.placeholdersProvider = PlaceholdersProvider(placeholders: placeholder)
        self.baseTableView.placeholderDelegate = self

        self.exchangeItems = self.exchangeItemsHandler.getExchangeItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Refreshing

    @objc
    func refreshTableView(refreshControl: UIRefreshControl) {
        self.perform(#selector(reloadTableViewData), with: nil, afterDelay: 1.5)
        self.refreshControl?.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 1.0)
    }

    @objc
    func reloadTableViewData() {
        self.tableView.reloadData()
    }

    // MARK: - Placeholders

    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        if placeholder.key == PlaceholderKey.noResultsKey {
            self.performSegue(withIdentifier: "newExchangeItemSegue", sender: self)
        }
    }

    private func customPlaceholder() -> Placeholder {
        var customPlaceholderStyle = PlaceholderStyle()
        customPlaceholderStyle.titleColor = .darkGray

        customPlaceholderStyle.shouldShowTableViewHeader = true
        customPlaceholderStyle.shouldShowTableViewFooter = true

        var customPlaceholderData = PlaceholderData()
        customPlaceholderData.title = NSLocalizedString("No data", comment: "")
        customPlaceholderData.subtitle = NSLocalizedString("If you want to see something more then this picture\nadd a new exchange data", comment: "")
        customPlaceholderData.image = UIImage(named: "empty-exchanges")
        customPlaceholderData.action = NSLocalizedString("New exchange", comment: "")

        let placeholder = Placeholder(data: customPlaceholderData, style: customPlaceholderStyle, key: PlaceholderKey.noResultsKey)
        return placeholder
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exchangeItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeitemcell", for: indexPath)
        guard let exchangeItemTableViewCell = cell as? ExchangeItemTableViewCell else {
            return cell
        }

        let exchangeItem = self.exchangeItems[indexPath.row]
        exchangeItemTableViewCell.exchangeItem = exchangeItem
        exchangeItemTableViewCell.isDarkMode = self.settings.isDarkMode

        return exchangeItemTableViewCell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default,
                                                title: "Delete",
                                                handler: { (_: UITableViewRowAction, indexPath: IndexPath) -> Void in
            let exchangeItem = self.exchangeItems[indexPath.row]
            self.exchangeItemsHandler.deleteExchangeItemEntity(exchangeItem: exchangeItem)
            CoreDataHandler.shared.saveContext()

            self.exchangeItems = self.exchangeItemsHandler.getExchangeItems()
            self.tableView.reloadData()
        })

        deleteAction.backgroundColor = UIColor.main
        return [deleteAction]
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editExchangeItemSegue" {
            if let destination = segue.destination.children.first as? ExchangeItemTableViewController {
                if let selectedPath = self.tableView.indexPathForSelectedRow {
                    destination.exchangeItem = self.exchangeItems[selectedPath.row]
                }

                destination.delegate = self
            }
        } else if segue.identifier == "newExchangeItemSegue" {
            if let destination = segue.destination.children.first as? ExchangeItemTableViewController {
                destination.delegate = self
            }
        }
    }

    // MARK: - Changed values delegate

    func exchange(changed: ExchangeItem) {
        CoreDataHandler.shared.saveContext()

        self.exchangeItems = self.exchangeItemsHandler.getExchangeItems()
        self.tableView.reloadData()
    }
}
