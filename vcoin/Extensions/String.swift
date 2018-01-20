//
//  String.swift
//  vcoin
//
//  Created by Marcin Czachurski on 20.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func openInBrowser() {
        if let url = URL(string: self) {
            UIApplication.shared.open(url , options: [:], completionHandler: nil)
        }
    }
}
