//
//  AlertTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 01.02.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import VCoinKit

protocol AlertChangedDelegate: NSObjectProtocol {
    func alert(changed: Alert)
}

class AlertTableViewController: BaseTableViewController, ChooseCurrencyDelegate, ChooseMarketDelegate {
    @IBOutlet private weak var priceLabelOutlet: UILabel!
    @IBOutlet private weak var priceOutlet: UITextField!
    @IBOutlet private weak var currencyOutlet: UILabel!
    @IBOutlet private weak var marketOutlet: UILabel!
    @IBOutlet private weak var saveButtonOutlet: UIBarButtonItem!

    weak var delegate: AlertChangedDelegate?
    var coin: Coin!
    var alert: Alert?

    private var alertsHandler = AlertsHandler()

    // MARK: - View loading

    override func viewDidLoad() {
        super.viewDidLoad()

        self.currencyOutlet.text = self.alert?.currency
        self.marketOutlet.text = self.alert?.marketCode

        self.priceOutlet.text = ""
        if let price = self.alert?.price {
            self.priceOutlet.text = String(price)
        }

        self.validateInputs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.currencyOutlet.text.isNilOrEmpty {
            self.currencyOutlet.text = self.settings.currency
        }

        if self.marketOutlet.text.isNilOrEmpty {
            self.marketOutlet.text = "CCCAGG"
        }

        self.priceOutlet.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Validation

    private func validateInputs() {
        if self.marketOutlet.text.isNilOrEmpty || self.currencyOutlet.text.isNilOrEmpty ||
            self.priceOutlet.text.isNilOrEmpty {
            self.saveButtonOutlet.isEnabled = false
            return
        }

        self.saveButtonOutlet.isEnabled = true
    }

    // MARK: - Theme style

    override func enableDarkMode() {
        super.enableDarkMode()
        self.priceLabelOutlet.textColor = UIColor.white
        self.priceOutlet.textColor = UIColor.white
    }

    override func disableDarkMode() {
        super.disableDarkMode()
        self.priceLabelOutlet.textColor = UIColor.black
        self.priceOutlet.textColor = UIColor.black
    }

    // MARK: - Actions

    @IBAction private func saveAction(_ sender: UIBarButtonItem) {
        if let alert = self.alert {
            self.save(alert: alert)
        } else {
            let alert = self.alertsHandler.createAlertEntity()
            self.alert = alert
            self.save(alert: alert)
        }
    }

    @IBAction private func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func priceChangedAction(_ sender: UITextField) {
        self.validateInputs()
    }

    private func save(alert: Alert) {
        if let priceTextValue = self.priceOutlet.text {
            alert.price = priceTextValue.doubleValue
        } else {
            alert.price = 0.0
        }

        if let marketCode = self.marketOutlet.text, let currency = self.currencyOutlet.text {
            alert.marketCode = marketCode
            alert.currency = currency
        }

        alert.coinSymbol = self.coin.Symbol
        alert.isPriceLower = alert.price <= (self.coin.Price ?? 0.0)

        self.delegate?.alert(changed: alert)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.priceOutlet.becomeFirstResponder()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "alertCurrencySegue" {
            if let destination = segue.destination as? ChooseCurrencyTableViewController {
                destination.settings = self.settings
                destination.selectedCurrency = self.currencyOutlet.text
                destination.delegate = self
            }
        } else if segue.identifier == "alertMarketSegue" {
            if let destination = segue.destination as? ChooseMarketTableViewController {
                destination.settings = self.settings
                destination.selectedMarket = self.marketOutlet.text
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
        self.marketOutlet.text = selected
        self.validateInputs()
    }
}
