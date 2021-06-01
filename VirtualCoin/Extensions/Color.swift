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
        return Color("AccentColor")
    }

    static func main(opacity: Double) -> Color {
        return Color.main.opacity(opacity)
    }

    static var greenPastel: Color {
        return Color("GreenPastel")
    }

    static var redPastel: Color {
        return Color("RedPastel")
    }
}