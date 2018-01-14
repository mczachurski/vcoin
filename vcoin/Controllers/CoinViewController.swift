//
//  CoinViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 07.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import Charts
import SwipeMenuViewController

class CoinViewController: UIViewController, ChartViewDelegate, SwipeMenuViewDelegate, SwipeMenuViewDataSource {

    public var coin:Coin?
    public var coinPercentage:[Int:Double] = [:]
    
    @IBOutlet weak var swipeMenuView: SwipeMenuView! {
        didSet {
            swipeMenuView.delegate = self
            swipeMenuView.dataSource = self
            
            var options = SwipeMenuViewOptions()
            options.tabView.style = .segmented
            options.tabView.margin = 8.0
            options.tabView.underlineView.backgroundColor = UIColor.main
            options.tabView.backgroundColor = UIColor.black
            options.tabView.underlineView.height = 1.0
            options.tabView.itemView.textColor = UIColor.gray
            options.tabView.itemView.selectedTextColor = UIColor.main
            options.contentScrollView.backgroundColor = UIColor.black
            
            self.swipeMenuView.reloadData(options: options)
        }
    }
    
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinShort: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinDifference: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        self.coinName.text = self.coin?.CoinName
        self.coinShort.text = self.coin?.Symbol
        self.coinPrice.text = self.coin?.Price?.toFormattedPrice()
        self.coinDifference.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getChartValues(chartRange: ChartRange, index: Int) -> LineChartView {
        
        let short = self.coin!.Symbol!
        let lineChart = LineChartView()
        lineChart.delegate = self
        
        self.setNoDataText(lineChart: lineChart, title: "Loading...")
        
        var apiUrl = ""
        switch chartRange {
        case .hour:
            apiUrl = "https://min-api.cryptocompare.com/data/histominute?fsym=\(short)&tsym=USD&limit=20&aggregate=3"
        case .day:
            apiUrl = "https://min-api.cryptocompare.com/data/histohour?fsym=\(short)&tsym=USD&limit=24"
        case .week:
            apiUrl = "https://min-api.cryptocompare.com/data/histohour?fsym=\(short)&tsym=USD&limit=21&aggregate=8"
        case .month:
            apiUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(short)&tsym=USD&limit=30"
        case .year:
            apiUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(short)&tsym=USD&limit=36&aggregate=10"
        }
        
        let request = URLRequest(url: URL(string: apiUrl)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    if let coinsValues = json["Data"] as? [AnyObject] {
                        self.loadChart(lineChart: lineChart, coinValues: coinsValues, index: index)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.setNoDataText(lineChart: lineChart, title: "Error during downloading chart data.")
                }
            }
        })
        
        
        task.resume()
        return lineChart
    }
    
    private func loadChart(lineChart: LineChartView, coinValues: [AnyObject], index: Int) {
        
        if coinValues.count == 0 {
            DispatchQueue.main.async {
                self.setNoDataText(lineChart: lineChart, title: "No data to draw chart.")
            }
            return
        }
        
        var firstPrice = 0.0
        var lastPrice = 0.0
        
        var values = [ChartDataEntry]()
        for (index, coinValue) in coinValues.enumerated() {
            if let coinValueDictionary = coinValue as? [String:Any] {
                if let hight = coinValueDictionary["high"] as? Double {
                    values.append(ChartDataEntry(x: Double(index + 1), y: hight))
                    
                    if index == 0 {
                        firstPrice = hight
                    }
                    
                    lastPrice = hight
                }
            }
        }
        
        self.coinPercentage[index] = ((lastPrice - firstPrice) / firstPrice.absoluteValue) * 100.0
        
        if index == 0 {
            DispatchQueue.main.async {
                self.renderDifference(index: index)
            }
        }
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(UIColor.main)
        set1.setCircleColor(.red)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formLineWidth = 15
        set1.drawValuesEnabled = false
        set1.drawCirclesEnabled = false
        
        let gradientColors = [UIColor.main(alpha: 0.0).cgColor, UIColor.main(alpha: 0.3).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        set1.mode = .cubicBezier
        
        let data = LineChartData(dataSet: set1)
        lineChart.legend.enabled = false
        lineChart.drawBordersEnabled = false
        lineChart.xAxis.enabled = false
        lineChart.leftAxis.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.dragEnabled = false
        lineChart.pinchZoomEnabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        
        DispatchQueue.main.async {
            lineChart.data = data
        }
    }
    
    fileprivate func renderDifference(index: Int) {
        if let difference = self.coinPercentage[index] {
            self.coinDifference.text = String(describing: difference.rounded(toPlaces: 2)) + " %"
            if difference >= 0 {
                self.coinDifference.textColor = .greenPastel
            }
            else {
                self.coinDifference.textColor = .redPastel
            }
        }
    }
    
    private func setNoDataText(lineChart: LineChartView, title: String) {
        lineChart.noDataText = title
        lineChart.noDataTextColor = .white
        lineChart.notifyDataSetChanged()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let value = entry.y
        self.coinPrice.text = value.toFormattedPrice()
    }
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return ChartRange.allValues.count
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        renderDifference(index: toIndex)
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return ChartRange.allValues[index].rawValue
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = UIViewController()
        
        let chartRange = ChartRange.allValues[index]
        vc.view = self.getChartValues(chartRange: chartRange, index: index)

        return vc
    }
}
