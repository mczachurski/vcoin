//
//  AlertsTableViewController.swift
//  VCoin
//
//  Created by Marcin Czachurski on 28.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class AlertsTableViewController: BaseTableViewController, AlertChangedDelegate {

    private var alertsHandler = AlertsHandler()
    private var alerts: [Alert] = []
    public var coinSymbol: String!
    
    private var baseTableView:BaseTableView {
        get {
            return self.tableView as! BaseTableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alerts = self.alertsHandler.getAlerts(coinSymbol: self.coinSymbol)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alerts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertcellitem", for: indexPath) as! AlertTableViewCell
        
        let alert = self.alerts[indexPath.row]
        cell.alert = alert
        cell.isDarkMode = self.settings.isDarkMode

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            let alert = self.alerts[indexPath.row]
            self.alertsHandler.deleteAlertEntity(alert: alert)
            CoreDataHandler.shared.saveContext()
            
            self.alerts = self.alertsHandler.getAlerts(coinSymbol: self.coinSymbol)
            self.tableView.reloadData()
        })
        
        deleteAction.backgroundColor = UIColor.main
        return [deleteAction]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAlertSegue" {
            if let destination = segue.destination.childViewControllers.first as? AlertTableViewController {
                if let selectedPath = self.tableView.indexPathForSelectedRow {
                    destination.alert = self.alerts[selectedPath.row]
                }
                
                destination.coinSymbol = self.coinSymbol
                destination.delegate = self
            }
        }
        else if segue.identifier == "newAlertSegue" {
            if let destination = segue.destination.childViewControllers.first as? AlertTableViewController {
                destination.coinSymbol = self.coinSymbol
                destination.delegate = self
            }
        }
    }
    
    // MARK: - Changed values delegate
    
    func alert(changed: Alert) {
        
        CoreDataHandler.shared.saveContext()
        
        self.alerts = self.alertsHandler.getAlerts(coinSymbol: self.coinSymbol)
        self.tableView.reloadData()
    }
}
