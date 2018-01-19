//
//  ThirdPartyTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 19.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class ThirdPartyTableViewController: UITableViewController {

    // MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.removeNavigationBarSeparator()
        self.removeTableViewCellSeparator()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.unselectSelectedRow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setSelectedColor(color: UIColor.darkBackground)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row)
        {
        case 0:
            UIApplication.shared.open(URL(string: "https://www.cryptocompare.com")! , options: [:], completionHandler: nil)
        case 1:
            UIApplication.shared.open(URL(string: "https://github.com/danielgindi/Charts")! , options: [:], completionHandler: nil)
        case 2:
            UIApplication.shared.open(URL(string: "https://github.com/yysskk/SwipeMenuViewController")! , options: [:], completionHandler: nil)
        default:
            break;
        }
    }

}
