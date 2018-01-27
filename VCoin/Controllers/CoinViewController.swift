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
import VCoinKit

class CoinViewController: BaseViewController, ChartViewDelegate, ChartDifferenceDelegate, SwipeMenuViewDelegate, SwipeMenuViewDataSource {

    public var coin:Coin!
    
    private var charts:[Int:CustomLineChartView] = [:]
    private var favouritesHandler = FavouritesHandler()
    private var isFavourite = false
    
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinShort: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinDifference: UILabel!
    @IBOutlet weak var favouriteButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var historicDate: UILabel!
    @IBOutlet weak var historicPrice: UILabel!
    
    @IBOutlet weak var swipeMenuView: SwipeMenuView! {
        didSet {
            swipeMenuView.delegate = self
            swipeMenuView.dataSource = self
            swipeMenuView.setCustomOptions()
        }
    }
    
    // MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        self.coinName.text = self.coin.CoinName
        self.coinShort.text = self.coin.Symbol
        self.coinPrice.text = self.coin.Price?.toFormattedPrice(currency: self.settings.currency!)

        self.coinDifference.text = (0.0).toFormattedPercent()
        self.coinDifference.textColor = .greenPastel
        
        self.historicPrice.text = ""
        self.historicDate.text = ""
        
        self.setFavouriteButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Favourites
    
    @IBAction func toggleFavourites(_ sender: UIBarButtonItem) {
        if self.isFavourite {
            self.favouritesHandler.deleteFavouriteEntity(symbol: coin.Symbol)
        }
        else {
            let favourite = self.favouritesHandler.createFavouriteEntity()
            favourite.coinSymbol = self.coin.Symbol
        }
        
        CoreDataHandler.shared.saveContext()
        self.setFavouriteButton()
    }
    
    private func setFavouriteButton() {
        self.isFavourite = self.favouritesHandler.isFavourite(symbol: coin.Symbol)
        if self.isFavourite {
            self.favouriteButtonOutlet.image = UIImage(named: "star-selected")
        }
        else {
            self.favouriteButtonOutlet.image = UIImage(named: "star-not-selected")
        }
    }
    
    // MARK: - Theme style
    
    override func enableDarkMode() {
        super.enableDarkMode()
        
        for chart in charts {
            chart.value.backgroundColor = UIColor.black
        }
        
        self.coinName.textColor = UIColor.white
        self.coinPrice.textColor = UIColor.white
    }

    override func disableDarkMode() {
        super.disableDarkMode()
        
        for chart in charts {
            chart.value.backgroundColor = UIColor.white
        }
        
        self.coinName.textColor = UIColor.black
        self.coinPrice.textColor = UIColor.black
    }
    
    // MARK: - ChartViewDelegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let value = entry.y
        
        if let customChartDataEntry = entry as? CustomChartDataEntry, let time = customChartDataEntry.time {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm"
            self.historicDate.text = dateFormatter.string(from: time)
        }
        
        self.historicPrice.text = value.toFormattedPrice(currency: self.settings.currency!)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.historicPrice.text = ""
        self.historicDate.text = ""
    }
    
    func differenceWasCalculated(chartView: CustomLineChartView, percentageDifference: Double) {
        if chartView.chartRange == ChartTimeRange.hour {
            self.changePercantageDifference(chartView: chartView)
        }
    }
    
    // MARK: - SwipeMenuViewDelegate
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        if let chartView = self.charts[toIndex] {
            self.changePercantageDifference(chartView: chartView)
        }
        
        self.historicPrice.text = ""
        self.historicDate.text = ""
    }
    
    // MARK: - SwipeMenuViewDataSource
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return ChartTimeRange.allValues.count
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return ChartTimeRange.allValues[index].rawValue
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let chartRange = ChartTimeRange.allValues[index]
        
        let lineChartView = CustomLineChartView(chartRange: chartRange, delegate: self, percentageDelegate: self)
        self.charts[index] = lineChartView
        
        lineChartView.loadCharViewData(symbol: self.coin.Symbol)
        
        let viewController = UIViewController()
        viewController.view = lineChartView
        return viewController
    }
    
    // MARK: - Change percentage
    
    private func changePercantageDifference(chartView: CustomLineChartView) {
        DispatchQueue.main.async {
            self.coinDifference.text = chartView.percentageDifference.toFormattedPercent()
            if chartView.percentageDifference >= 0 {
                self.coinDifference.textColor = UIColor.greenPastel
            }
            else {
                self.coinDifference.textColor = UIColor.redPastel
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coinmarkets" {
            if let destination = segue.destination as? MarketsTableViewController {
                destination.coin = self.coin
            }
        }
    }
}
