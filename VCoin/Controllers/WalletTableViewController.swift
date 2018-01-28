//
//  WalletTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class WalletTableViewController: BaseTableViewController, WalletItemChangedDelegate {

    private var walletItemsHandler = WalletItemsHandler()
    private var walletItems: [WalletItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.walletItems = self.walletItemsHandler.getWalletItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletitemcell", for: indexPath) as! WalletItemTableViewCell

        // Configure the cell...
        let walletItem = self.walletItems[indexPath.row]
        cell.walletItem = walletItem
        
        if indexPath.row == 0 {
            cell.customBacgroundColor = UIColor.main
        }
        if indexPath.row == 1 {
            cell.customBacgroundColor = UIColor(red: 254.0 / 255.0, green: 100.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
        }
        else if indexPath.row == 2 {
            cell.customBacgroundColor = UIColor(red: 73.0 / 255.0, green: 99.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
        }
        else if indexPath.row == 3 {
            cell.customBacgroundColor = UIColor(red: 44.0 / 255.0, green: 209.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
        }
        
        return cell
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
