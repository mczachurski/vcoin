//
//  CustomChartDataEntry.swift
//  VCoin
//
//  Created by Marcin Czachurski on 24.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import Charts

class CustomChartDataEntry : ChartDataEntry {
    public var time: Date?
    
    public init(x: Double, y: Double, timestamp: Any?) {
        super.init(x: x, y: y)
        
        if let unixTimestamp = timestamp as? Double {
            let date = Date(timeIntervalSince1970: unixTimestamp)
            self.time = date
        }
    }
    
    required init() {
        super.init()
    }
}
