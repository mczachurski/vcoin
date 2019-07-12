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

    public func loadCoinsList(callback: @escaping ([Coin]) -> Void, errorCallback: @escaping (String) -> Void) {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/all/coinlist") else {
            errorCallback("Wrong URL to currencies list")
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, _, error -> Void in
            self.loadCoinsHandler(data: data, error: error, callback: callback, errorCallback: errorCallback)
        })

        task.resume()
    }

    private func loadCoinsHandler(data: Data?,
                                  error: Error?,
                                  callback: @escaping ([Coin]) -> Void,
                                  errorCallback: @escaping (String) -> Void) {
        if let errorMessage = error {
            print(errorMessage.localizedDescription)
            errorCallback(errorMessage.localizedDescription)
            return
        }

        var downloadedCoins: [Coin] = []

        do {
            if let jsonData = data, let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                if let coinsDict = json["Data"] as? [String: Any] {
                    for (_, data) in coinsDict {
                        if let coinData = data as? [String: Any] {
                            let coin = Coin(data: coinData)
                            downloadedCoins.append(coin)
                        }
                    }

                    downloadedCoins.sort {
                        var leftSortOrder = 0
                        if let leftSortOrderString = $0.SortOrder {
                            leftSortOrder = Int(leftSortOrderString) ?? 0
                        }

                        var rightSortOrder = 0
                        if let rightSortOrderString = $1.SortOrder {
                            rightSortOrder = Int(rightSortOrderString) ?? 0
                        }

                        return leftSortOrder < rightSortOrder
                    }
                }
            }

            callback(downloadedCoins)
        } catch {
            errorCallback("Currencies wasn't downloaded")
        }
    }

    public func loadCoinPrice(symbol: String,
                              currency: String,
                              callback: @escaping (Double?) -> Void,
                              errorCallback: ((String) -> Void)? = nil) {
        loadCoinPrice(symbol: symbol,
                      currency: currency,
                      market: "CCCAGG",
                      callback: callback,
                      errorCallback: errorCallback)
    }

    public func loadCoinPrice(symbol: String,
                              currency: String,
                              market: String,
                              callback: @escaping (Double?) -> Void,
                              errorCallback: ((String) -> Void)? = nil) {
        var price: Double?

        guard let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(symbol)&tsyms=\(currency)&e=\(market)") else {
            errorCallback?("Wrong URL to currencies list")
            return
        }

        let priceRequest = URLRequest(url: url)
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, _, error -> Void in
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
                callback(price)
                return
            }

            do {
                if let jsonData = priceData, let priceJson = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Double] {
                    price = priceJson[currency]
                }

                callback(price)
            } catch {
                print("loadCoinPrice error")
            }
        })

        priceTask.resume()
    }

    public func loadCoinChange(symbol: String,
                               callback: @escaping (Double?) -> Void,
                               errorCallback: ((String) -> Void)? = nil) {
        var priceChange: Double?

        guard let url = URL(string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=\(symbol)&tsym=USD&e=CCCAGG") else {
            errorCallback?("Wrong URL to currencies list")
            return
        }

        let priceRequest = URLRequest(url: url)
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, _, error -> Void in
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
                callback(priceChange)
                return
            }

            do {
                if let jsonData = priceData, let priceJson = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    if let priceData = priceJson["RAW"] as? [String: Any] {
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

    public func loadCharViewData(chartRange: ChartTimeRange,
                                 symbol: String,
                                 currency: String,
                                 callback: @escaping ([AnyObject]) -> Void,
                                 errorCallback: ((String) -> Void)? = nil) {
        var apiUrl = ""
        switch chartRange {
        case .hour:
            apiUrl = "https://min-api.cryptocompare.com/data/histominute?fsym=\(symbol)&tsym=\(currency)&limit=20&aggregate=3&e=CCCAGG"
        case .day:
            apiUrl = "https://min-api.cryptocompare.com/data/histohour?fsym=\(symbol)&tsym=\(currency)&limit=24&e=CCCAGG"
        case .week:
            apiUrl = "https://min-api.cryptocompare.com/data/histohour?fsym=\(symbol)&tsym=\(currency)&limit=21&aggregate=8&e=CCCAGG"
        case .month:
            apiUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=\(currency)&limit=30&e=CCCAGG"
        case .year:
            apiUrl = "https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=\(currency)&limit=36&aggregate=10&e=CCCAGG"
        }

        var coinsValues: [AnyObject] = []

        guard let url = URL(string: apiUrl) else {
            errorCallback?("Wrong URL to currencies list")
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, _, error -> Void in
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
                callback(coinsValues)
                return
            }

            do {
                if let jsonData = data, let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
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
