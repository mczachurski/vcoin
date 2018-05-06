//
//  String.swift
//  vcoin
//
//  Created by Marcin Czachurski on 20.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}

extension String {

    func openInBrowser() {
        if let url = URL(string: self) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    var doubleValue: Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."

        if let result = numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            numberFormatter.decimalSeparator = ","
            if let result = numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }

        return 0
    }
}
