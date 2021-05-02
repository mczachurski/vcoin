//
//  ChartRange.swift
//  vcoin
//
//  Created by Marcin Czachurski on 14.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public enum ChartTimeRange: String {
    case hour = "Hour", day = "Day", week = "Week", month = "Month", year = "Year"

    public static let allValues = [hour, day, week, month, year]
}
