//
//  SettingsTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class SettingsTableViewController: BaseTableViewController, ChooseCurrencyDelegate {

    @IBOutlet weak var currencyOutlet: UILabel!
    @IBOutlet weak var darkModeSwitchOutlet: UISwitch!
    @IBOutlet weak var darkModeLabelOutlet: UILabel!
    @IBOutlet weak var versionLabelOutlet: UILabel!
    
    // MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.versionLabelOutlet.text = getAppVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currencyOutlet.text = self.settings.currency
        self.darkModeSwitchOutlet.isOn = self.settings.isDarkMode
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Application version
    
    func getAppVersion() -> String {
        return "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? "")"
    }
    
    // MARK: - Theme style
    
    override func enableDarkMode() {
        super.enableDarkMode()
        self.darkModeLabelOutlet.textColor = UIColor.white
        self.darkModeSwitchOutlet.setOn(true, animated: true)
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        self.darkModeLabelOutlet.textColor = UIColor.black
        self.darkModeSwitchOutlet.setOn(false, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func toggleDarkModeSwitch(_ sender: UISwitch) {
        self.settings?.isDarkMode = sender.isOn
        CoreDataHandler.shared.saveContext()
        
        NotificationCenter.default.post(name: sender.isOn ? .darkModeEnabled : .darkModeDisabled, object: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.unselectSelectedRow()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            "https://github.com/mczachurski/vcoin".openInBrowser()
        }
        else if indexPath.section == 1 && indexPath.row == 2 {
            "https://github.com/mczachurski/vcoin/issues".openInBrowser()
        }
        else if indexPath.section == 1 && indexPath.row == 3 {
            "https://twitter.com/mczachurski".openInBrowser()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currencySegue" {
            if let destination = segue.destination as? ChooseCurrencyTableViewController {
                destination.settings = self.settings
                destination.selectedCurrency = self.settings?.currency
                
                destination.delegate = self
            }
        }
    }
    
    // MARK: - Choose currency protocol
    
    func chooseCurrency(selected: String?) {
        self.settings.currency = selected
        CoreDataHandler.shared.saveContext()
    }
}
