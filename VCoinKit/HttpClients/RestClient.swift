//
//  RestClient.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class RestClient {
    
    public init() {
    }
    
    public func loadCoinsList(callback: @escaping ([Coin]) -> (), errorCallback: @escaping (String) -> ()) {
        var downloadedCoins:[Coin] = []
        
        let request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/all/coinlist")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
                errorCallback(errorMessage.localizedDescription)
                return
            }
            
            do {
                if let jsonData = data, let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
                    if let coinsDict = json["Data"] as? [String:Any] {
                        
                        for (_, data) in coinsDict {
                            if let coinData = data as? [String:Any] {
                                let coin = Coin(data: coinData)
                                downloadedCoins.append(coin)
                            }
                        }
                        
                        downloadedCoins.sort {
                            let coin1Sort = Int($0.SortOrder!)
                            let coin2Sort = Int($1.SortOrder!)
                            return coin1Sort! < coin2Sort!
                        }
                    }
                }
                
                callback(downloadedCoins)
            } catch {
                errorCallback("Currencies wasn't downloaded")
            }
        })
        
        task.resume()
    }
    
    public func loadCoinPrice(symbol: String, currency: String, callback: @escaping (Double?) -> ()) {
        
        var price: Double? = nil
        
        let priceRequest = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(symbol)&tsyms=\(currency)&e=CCCAGG")!)
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, response, error -> Void in
            
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
                callback(price)
                return
            }
            
            do {
                if let jsonData = priceData, let priceJson = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Double] {
                    price = priceJson[currency]
                }
                
                callback(price)
            } catch {
                print("loadCoinPrice error")
            }
        })
        
        priceTask.resume()
    }
    
    public func loadCoinChange(symbol: String, callback: @escaping (Double?) -> ()) {
        
        var priceChange: Double? = nil
        
        let priceRequest = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=\(symbol)&tsym=USD&e=CCCAGG")!)
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, response, error -> Void in
            
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
                callback(priceChange)
                return
            }
            
            do {
                if let jsonData = priceData, let priceJson = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
                    if let priceData = priceJson["RAW"] as? [String:Any] {
                        if let changePercantage = priceData["CHANGEPCT24HOUR"] as? Double {
                            priceChange = changePercantage
                        }
                    }
                }
                
                callback(priceChange)
            } catch {
                print("loadCoinChange error")
            }
        })
        
        priceTask.resume()
    }
    
    public func loadCharViewData(chartRange: ChartTimeRange, symbol: String, callback: @escaping ([AnyObject]) -> ()) {
        var apiUrl = ""
        switch chartRange {
        case .hour:
            apiUrl = "https://min-api.cryptocompare.com/data/histominute?fsym=\(symbol)&tsym=USD&limit=20&aggregate=3&e=CCCAGG"
        case .day:
            apiUrl = "https://min-api.cryptocompare.com/data/histohour?fsym=\(symbol)&tsym=USD&limit=24&e=CCCAGG"
        case .week:
            apiUrl = "https://min-api.cryptocompare.com/data/histohour?fsym=\(symbol)&tsym=USD&limit=21&aggregate=8&e=CCCAGG"
        case .month:
            apiUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30&e=CCCAGG"
        case .year:
            apiUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=36&aggregate=10&e=CCCAGG"
        }
        
        var coinsValues: [AnyObject] = []
        
        let request = URLRequest(url: URL(string: apiUrl)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
                callback(coinsValues)
                return
            }
            
            do {
                if let jsonData = data, let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
                    if let values = json["Data"] as? [AnyObject] {
                        coinsValues = values
                    }
                }
                
                callback(coinsValues)
            } catch {
                print("loadCharViewData error")
            }
        })
        
        task.resume()
    }
}
