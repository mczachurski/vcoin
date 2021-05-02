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
    case networkFailure(Error)
    case badDataFormat(Error)
}
