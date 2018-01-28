//
//  WalletItemTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class WalletItemTableViewController: BaseTableViewController, ChooseCurrencyProtocol, ChooseMarketProtocol {

    @IBOutlet weak var cryptoCodeOutlet: UILabel!
    @IBOutlet weak var amountOutlet: UILabel!
    @IBOutlet weak var marketCodeOutlet: UILabel!
    @IBOutlet weak var currencyOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currencySegue" {
            if let destination = segue.destination as? ChooseCurrencyTableViewController {
                destination.settings = self.settings
                destination.selectedCurrency = self.currencyOutlet.text
                destination.delegate = self
            }
        }
        else if segue.identifier == "marketSegue" {
            if let destination = segue.destination as? ChooseMarketTableViewController {
                destination.settings = self.settings
                destination.selectedMarket = self.marketCodeOutlet.text
                destination.delegate = self
            }
        }
        else if segue.identifier == "cryptoSegue" {
            
        }
    }
    
    // MARK: - Change values protocols
    
    func chooseCurrency(selected: String?) {
        self.currencyOutlet.text = selected
    }
    
    func chooseMarket(selected: String?) {
        self.marketCodeOutlet.text = selected
    }
}
