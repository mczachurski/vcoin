//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    
import SwiftUI
import LightChart

extension CurrentValueLineType {
    static var red: CurrentValueLineType {
        get {
            CurrentValueLineType.dash(color: .redPastel, lineWidth: 1, dash: [5])
        }
    }
    
    static var green: CurrentValueLineType {
        get {
            CurrentValueLineType.dash(color: .greenPastel, lineWidth: 1, dash: [5])
        }
    }
}
