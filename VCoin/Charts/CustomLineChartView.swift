//
//  LineChartView.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import Charts
import VCoinKit

class CustomLineChartView: LineChartView {

    public var percentageDifference: Double = 0.0
    public weak var percentageDelegate: ChartDifferenceDelegate?
    public var chartRange: ChartTimeRange = ChartTimeRange.hour

    private var restClient = RestClient()

    convenience init(chartRange: ChartTimeRange, delegate: ChartViewDelegate, percentageDelegate: ChartDifferenceDelegate) {
        self.init()

        self.chartRange = chartRange

        self.delegate = delegate
        self.percentageDelegate = percentageDelegate

        self.setCustomChartStyle()
        self.setNoDataText(title: "Loading...")
    }

    func loadCharViewData(symbol: String, currency: String) {
        self.restClient.loadCharViewData(chartRange: self.chartRange, symbol: symbol, currency: currency) { (chartValues) in
            self.renderChartViewData(coinValues: chartValues)
        }
    }

    private func renderChartViewData(coinValues: [AnyObject]) {

        if coinValues.count == 0 {
            DispatchQueue.main.async {
                self.setNoDataText(title: "No data to draw chart.")
            }
            return
        }

        var firstPrice = 0.0
        var lastPrice = 0.0

        var values = [ChartDataEntry]()
        for (index, coinValue) in coinValues.enumerated() {
            if let coinValueDictionary = coinValue as? [String: Any] {
                if let hight = coinValueDictionary["high"] as? Double {

                    let chartDataEntry = CustomChartDataEntry(x: Double(index + 1), y: hight, timestamp: coinValueDictionary["time"])
                    values.append(chartDataEntry)

                    if index == 0 {
                        firstPrice = hight
                    }

                    lastPrice = hight
                }
            }
        }

        self.percentageDifference = ((lastPrice - firstPrice) / firstPrice.absoluteValue) * 100.0
        self.percentageDelegate?.differenceWasCalculated(chartView: self, percentageDifference: self.percentageDifference)

        let lineChartDataSet = self.createLineChartDataSet(values: values)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)

        DispatchQueue.main.async {
            self.data = lineChartData
        }
    }

    private func createLineChartDataSet(values: [ChartDataEntry]) -> LineChartDataSet {
        let lineChartDataSet = LineChartDataSet(values: values, label: "DataSet 1")
        lineChartDataSet.drawIconsEnabled = false
        lineChartDataSet.highlightLineDashLengths = [5, 2.5]
        lineChartDataSet.setColor(UIColor.main)
        lineChartDataSet.setCircleColor(.red)
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.circleRadius = 3
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.valueFont = .systemFont(ofSize: 9)
        lineChartDataSet.formLineDashLengths = [5, 2.5]
        lineChartDataSet.formLineWidth = 1
        lineChartDataSet.formLineWidth = 15
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false

        let gradientColors = [UIColor.main(alpha: 0.0).cgColor, UIColor.main(alpha: 0.3).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fill = Fill(linearGradient: gradient, angle: 90)
        lineChartDataSet.drawFilledEnabled = true

        lineChartDataSet.mode = .cubicBezier

        return lineChartDataSet
    }

    private func setNoDataText(title: String) {
        self.noDataText = title
        self.noDataTextColor = .gray
        self.notifyDataSetChanged()
    }

    private func setCustomChartStyle() {
        self.legend.enabled = false
        self.drawBordersEnabled = false
        self.xAxis.enabled = false
        self.leftAxis.enabled = false
        self.rightAxis.enabled = false
        self.dragEnabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.chartDescription?.text = ""
    }
}
