//
//  WalletTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import HGPlaceholders

class WalletTableViewController: BaseTableViewController, WalletItemChangedDelegate, PlaceholderDelegate {

    private var walletItemsHandler = WalletItemsHandler()
    private var walletItems: [WalletItem] = []
    
    private var baseTableView:BaseTableView {
        get {
            return self.tableView as! BaseTableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let placeholder = customPlaceholder()
        self.baseTableView.placeholdersProvider = PlaceholdersProvider(placeholders: placeholder)
        self.baseTableView.placeholderDelegate = self
        
        self.walletItems = self.walletItemsHandler.getWalletItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Placeholders
    
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        if placeholder.key == PlaceholderKey.noResultsKey {
            self.performSegue(withIdentifier: "newWalletItemSegue", sender:self)
        }
    }
    
    private func customPlaceholder() -> Placeholder {
        var customPlaceholderStyle = PlaceholderStyle()
        customPlaceholderStyle.titleColor = .darkGray
        
        var customPlaceholderData = PlaceholderData()
        customPlaceholderData.title = NSLocalizedString("No data", comment: "")
        customPlaceholderData.subtitle = NSLocalizedString("If you want to see something more then this picture\nadd a new exchange data", comment: "")
        customPlaceholderData.image = UIImage(named: "empty-wallet")
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
        return self.walletItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletitemcell", for: indexPath) as! WalletItemTableViewCell

        let walletItem = self.walletItems[indexPath.row]
        cell.walletItem = walletItem
        cell.isDarkMode = self.settings.isDarkMode
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            let walletItem = self.walletItems[indexPath.row]
            self.walletItemsHandler.deleteWalletItemEntity(walletItem: walletItem)
            CoreDataHandler.shared.saveContext()
            
            self.walletItems = self.walletItemsHandler.getWalletItems()
            self.tableView.reloadData()
        })
        
        return [deleteAction]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWalletItemSegue" {
            if let destination = segue.destination.childViewControllers.first as? WalletItemTableViewController {
                if let selectedPath = self.tableView.indexPathForSelectedRow {
                    destination.walletItem = self.walletItems[selectedPath.row]
                }
                
                destination.delegate = self
            }
        }
        else if segue.identifier == "newWalletItemSegue" {
            if let destination = segue.destination.childViewControllers.first as? WalletItemTableViewController {                
                destination.delegate = self
            }
        }
    }
    
    // MARK: - Changed values delegate
    
    func wallet(changed: WalletItem) {
        
        CoreDataHandler.shared.saveContext()
        
        self.walletItems = self.walletItemsHandler.getWalletItems()
        self.tableView.reloadData()
    }
}
