//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    static func runOnMain(_ handler: @escaping () -> Void) {
        if Thread.isMainThread {
            handler()
        } else {
            DispatchQueue.main.async(execute: handler)
        }
    }
}
