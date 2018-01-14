//
//  UIColor.swift
//  vcoin
//
//  Created by Marcin Czachurski on 14.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {    
    class var main: UIColor {
        get {
            return UIColor(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
        }
    }
    
    class func main(alpha:CGFloat) -> UIColor {
        return UIColor(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, alpha: alpha)
    }
    
    class var greenPastel: UIColor {
        get {
            return UIColor(red: 0.0 / 255.0, green: 169.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)
        }
    }
    
    class var redPastel: UIColor {
        get {
            return UIColor(red: 255.0 / 255.0, green: 54.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        }
    }
}
