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
    public class var main: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
    }

    public class func main(alpha: CGFloat) -> UIColor {
        return UIColor(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, alpha: alpha)
    }

    public class var darkBackground: UIColor {
        return UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
    }

    public class var lightBackground: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }

    public class var greenPastel: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 169.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)
    }

    public class var redPastel: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 54.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    }
}
