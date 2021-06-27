//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
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
    
    static var backgroundLabel: Color {
        return Color("BackgroundLabel")
    }
    
    static func backgroundLabel(opacity: Double) -> Color {
        return Color.backgroundLabel.opacity(opacity)
    }
}
