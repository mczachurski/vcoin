//
//  NotificationsErrors.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 04/06/2021.
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
