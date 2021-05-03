//
//  UIColor.swift
//  vcoin
//
//  Created by Marcin Czachurski on 14.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import SwiftUI

public extension Color {
    static var main: Color {
        return Color(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, opacity: 1.0)
    }

    static func main(alpha: Double) -> Color {
        return Color(red: 240.0 / 255.0, green: 101.0 / 255.0, blue: 8.0 / 255.0, opacity: alpha)
    }

    static var darkBackground: Color {
        return Color(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, opacity: 1.0)
    }

    static var lightBackground: Color {
        return Color(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, opacity: 1.0)
    }

    static var greenPastel: Color {
        return Color(red: 0.0 / 255.0, green: 169.0 / 255.0, blue: 108.0 / 255.0, opacity: 1.0)
    }

    static var redPastel: Color {
        return Color(red: 255.0 / 255.0, green: 54.0 / 255.0, blue: 53.0 / 255.0, opacity: 1.0)
    }
}
