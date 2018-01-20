//
//  ThirdPartyTableViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 19.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class ThirdPartyTableViewController: BaseTableViewController {

    // MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row)
        {
        case 0:
            "https://www.cryptocompare.com".openInBrowser()
        case 1:
            "https://github.com/danielgindi/Charts".openInBrowser()
        case 2:
            "https://github.com/yysskk/SwipeMenuViewController".openInBrowser()
        default:
            break;
        }
    }

}
