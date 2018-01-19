//
//  SettingsTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var settings: Settings! = nil
    var settingsHandler = SettingsHandler()
    
    @IBOutlet weak var currencyOutlet: UILabel!
    @IBOutlet weak var darkModeSwitchOutlet: UISwitch!
    
    // MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.removeNavigationBarSeparator()
        self.removeTableViewCellSeparator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.unselectSelectedRow()
        
        self.settings = settingsHandler.getDefaultSettings()
        
        self.currencyOutlet.text = self.settings.currency
        self.darkModeSwitchOutlet.isOn = self.settings.isDarkMode
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func toggleDarkModeSwitch(_ sender: UISwitch) {
        self.settings?.isDarkMode = sender.isOn
        self.settingsHandler.save(settings: self.settings)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setSelectedColor(color: UIColor.darkBackground)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.unselectSelectedRow()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            UIApplication.shared.open(URL(string: "https://github.com/mczachurski/vcoin")! , options: [:], completionHandler: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currencySegue" {
            if let destination = segue.destination as? CurrencyTableViewController {
                destination.settings = self.settings
            }
        }
    }
}
