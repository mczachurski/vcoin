//
//  ChartDifferenceDelegate.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

protocol ChartDifferenceDelegate {
    func differenceWasCalculated(chartView: CustomLineChartView, percentageDifference: Double)
}
