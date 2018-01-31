//
//  ExchangeItemChangedDelegate.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

protocol ExchangeItemChangedDelegate : NSObjectProtocol {
    func exchange(changed: ExchangeItem)
}

class ExchangeItemTableViewController: BaseTableViewController, ChooseCurrencyDelegate, ChooseMarketDelegate, ChooseCryptocurrencyDelegate {

    @IBOutlet weak var cryptoCodeOutlet: UILabel!
    @IBOutlet weak var marketCodeOutlet: UILabel!
    @IBOutlet weak var currencyOutlet: UILabel!
    @IBOutlet weak var amountLabelOutlet: UILabel!
    @IBOutlet weak var amountValueOutlet: UITextField!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    public weak var delegate: ExchangeItemChangedDelegate?
    
    public var exchangeItem: ExchangeItem?

    private var exchangeItemsHandler = ExchangeItemsHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.cryptoCodeOutlet.text = self.exchangeItem?.coinSymbol
        self.currencyOutlet.text = self.exchangeItem?.currency
        self.marketCodeOutlet.text = self.exchangeItem?.marketCode
        
        self.amountValueOutlet.text = ""
        if let amount = self.exchangeItem?.amount {
            self.amountValueOutlet.text = String(amount)
        }
        
        self.validateInputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.currencyOutlet.text.isNilOrEmpty {
            self.currencyOutlet.text = self.settings.currency
        }
        
        if self.marketCodeOutlet.text.isNilOrEmpty {
            self.marketCodeOutlet.text = "CCCAGG"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func validateInputs() {
        
        if self.marketCodeOutlet.text.isNilOrEmpty || self.currencyOutlet.text.isNilOrEmpty ||
            self.cryptoCodeOutlet.text.isNilOrEmpty || self.amountValueOutlet.text.isNilOrEmpty {
            self.saveButtonOutlet.isEnabled = false
            return
        }
        
        self.saveButtonOutlet.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        if self.exchangeItem == nil {
            self.exchangeItem = self.exchangeItemsHandler.createExchangeItemEntity()
        }
        
        if let amountTextValue = self.amountValueOutlet.text {
            exchangeItem?.amount = amountTextValue.doubleValue
        }
        else {
            exchangeItem?.amount = 0.0
        }
        
        exchangeItem?.marketCode = self.marketCodeOutlet.text
        exchangeItem?.currency = self.currencyOutlet.text
        exchangeItem?.coinSymbol = self.cryptoCodeOutlet.text
        
        self.delegate?.exchange(changed: exchangeItem!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func amountChangedAction(_ sender: UITextField) {
        self.validateInputs()
    }
    
    // MARK: - Theme style
    
    override func enableDarkMode() {
        super.enableDarkMode()
        self.amountLabelOutlet.textColor = UIColor.white
        self.amountValueOutlet.textColor = UIColor.white
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        self.amountLabelOutlet.textColor = UIColor.black
        self.amountValueOutlet.textColor = UIColor.black
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.amountValueOutlet.becomeFirstResponder()
        }
    }
    
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
            if let destination = segue.destination as? ChooseCryptocurrencyTableViewController {
                destination.settings = self.settings
                destination.selectedCryptocurrency = self.cryptoCodeOutlet.text
                destination.delegate = self
            }
        }
    }
    
    // MARK: - Change values protocols
    
    func chooseCurrency(selected: String?) {
        self.currencyOutlet.text = selected
        self.validateInputs()
    }
    
    func chooseMarket(selected: String?) {
        self.marketCodeOutlet.text = selected
        self.validateInputs()
    }
    
    func chooseCryptocurrency(selected: String?) {
        self.cryptoCodeOutlet.text = selected
        self.validateInputs()
    }
}
