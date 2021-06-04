//
//  RestClienError.swift
//  VCoinKit
//
//  Created by Marcin Czachurski on 12/07/2019.
//  Copyright © 2019 Marcin Czachurski. All rights reserved.
//

import Foundation

public enum RestClientError: Error {
    case badUrl
    case serverError
    case emptyDataError
    case numberBadFormat
    case networkFailure(Error)
    case badDataFormat(Error)
}

extension RestClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badUrl:
            return NSLocalizedString("Bad URL to coincap.io API.", comment: "")
        case .serverError:
            return NSLocalizedString("Server returns unexpected error.", comment: "")
        case .emptyDataError:
            return NSLocalizedString("Server returns empty data result.", comment: "")
        case .numberBadFormat:
            return NSLocalizedString("Server returns number which cannot be deserialized.", comment: "")
        case .networkFailure(let error):
            return NSLocalizedString(error.localizedDescription, comment: "")
        case .badDataFormat(let error):
            return NSLocalizedString(error.localizedDescription, comment: "")
        }
    }
}
