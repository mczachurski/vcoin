//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

public enum NotificationsError: Error {
    case notRecognizedCurrencySymbol
}

extension NotificationsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notRecognizedCurrencySymbol:
            return NSLocalizedString("Not recognized currency symbol.", comment: "")
        }
    }
}
