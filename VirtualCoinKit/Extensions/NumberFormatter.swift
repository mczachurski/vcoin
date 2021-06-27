//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public extension NumberFormatter {
    static var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
                
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
    
        return formatter
    }()
}
