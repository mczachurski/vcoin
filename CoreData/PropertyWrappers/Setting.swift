//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

@propertyWrapper public struct Setting<T>: DynamicProperty {
    private let keyPath: KeyPath<Settings, T>

    public var wrappedValue: T {
        get {
            let settingsHandler = SettingsHandler()
            let settings = settingsHandler.getDefaultSettings()
            
            return settings[keyPath: keyPath]
        }
    }
    
    public init(_ keyPath: KeyPath<Settings, T>) {
        self.keyPath = keyPath
    }
}
