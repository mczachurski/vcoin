//
//  CoinViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 07.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import Charts

class CoinViewController: UIViewController, ChartViewDelegate {

    public var coin:Coin?
    
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinShort: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var barChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.barChart.delegate = self
        self.barChart.noDataText = "Loading..."
        self.barChart.noDataTextColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        self.coinName.text = self.coin?.CoinName
        self.coinShort.text = self.coin?.Symbol
        self.coinPrice.text = self.coin?.Price?.toFormattedPrice()
        
        self.getChartValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getChartValues() {
        let short = self.coin!.Symbol!
        let request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/histominute?fsym=\(short)&tsym=USD&limit=60&aggregate=4")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    if let coinsValues = json["Data"] as? [AnyObject] {
                        self.loadChart(coinValues: coinsValues)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.barChart.noDataText = "Error during downloading chart data."
                    self.barChart.noDataTextColor = .white
                }
            }
        })
        
        task.resume()
    }
    
    private func loadChart(coinValues:[AnyObject]) {
        
        if coinValues.count == 0 {
            DispatchQueue.main.async {
                self.barChart.noDataText = "No data to draw chart."
                self.barChart.noDataTextColor = .white
                self.barChart.notifyDataSetChanged()
            }
            return
        }
        
        var values = [ChartDataEntry]()
        for (index, coinValue) in coinValues.enumerated() {
            if let coinValueDictionary = coinValue as? [String:Any] {
                if let hight = coinValueDictionary["high"] as? Float {
                    values.append(ChartDataEntry(x: Double(index + 1), y: Double(hight)))
                }
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
        self.barChart.legend.enabled = false
        self.barChart.drawBordersEnabled = false
        self.barChart.xAxis.enabled = false
        self.barChart.leftAxis.enabled = false
        self.barChart.rightAxis.enabled = false
        self.barChart.dragEnabled = false
        self.barChart.pinchZoomEnabled = false
        self.barChart.scaleXEnabled = false
        self.barChart.scaleYEnabled = false
        
        DispatchQueue.main.async {
            self.barChart.data = data
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let value = Float(entry.y)
        self.coinPrice.text = value.toFormattedPrice()
    }
}
