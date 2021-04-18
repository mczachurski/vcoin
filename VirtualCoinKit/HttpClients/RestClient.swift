//
//  RestClient.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class RestClient: ObservableObject {
    @Published public var coins: [Coin] = []
    
    public init() {
    }

    // MARK: - Load coin list

    public func loadCoinsList() {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/all/coinlist") else {
            // TODO: Fix
            // completionHandler(.failure(.badUrl))
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, _, error -> Void in
            if let error = error {
                // TODO: Fix
                // completionHandler(.failure(.networkFailure(error)))
                print(error)
                return
            }

            let result = self.loadCoinsHandler(data: data)
            switch result {
            case .success(let downloadedCoins):
                DispatchQueue.main.async {
                    self.coins = downloadedCoins
                }
            case .failure(let error):
                print(error)
            }
        })

        task.resume()
    }

    private func loadCoinsHandler(data: Data?) -> Result<[Coin], RestClientError> {
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
                        if let leftSortOrderString = $0.sortOrder {
                            leftSortOrder = Int(leftSortOrderString) ?? 0
                        }

                        var rightSortOrder = 0
                        if let rightSortOrderString = $1.sortOrder {
                            rightSortOrder = Int(rightSortOrderString) ?? 0
                        }

                        return leftSortOrder < rightSortOrder
                    }
                }
            }

            return .success(downloadedCoins)
        } catch {
            return .failure(.badDataFormat(error))
        }
    }

    // MARK: - Load coin price

    public func loadCoinPrice(symbol: String,
                              currency: String,
                              completionHandler: @escaping (Result<Double?, RestClientError>) -> Void) {
        loadCoinPrice(symbol: symbol,
                      currency: currency,
                      market: "CCCAGG",
                      completionHandler: completionHandler)
    }

    public func loadCoinPrice(symbol: String,
                              currency: String,
                              market: String,
                              completionHandler: @escaping (Result<Double?, RestClientError>) -> Void) {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(symbol)&tsyms=\(currency)&e=\(market)") else {
            completionHandler(.failure(.badUrl))
            return
        }

        var price: Double?
        let priceRequest = URLRequest(url: url)
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, _, error -> Void in
            if let error = error {
                completionHandler(.failure(.networkFailure(error)))
                return
            }

            do {
                if let jsonData = priceData, let priceJson = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Double] {
                    price = priceJson[currency]
                }

                completionHandler(.success(price))
            } catch {
                completionHandler(.failure(.badDataFormat(error)))
            }
        })

        priceTask.resume()
    }

    // MARK: - Load coin change

    public func loadCoinChange(symbol: String, completionHandler: @escaping (Result<Double?, RestClientError>) -> Void) {
        var priceChange: Double?

        guard let url = URL(string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=\(symbol)&tsym=USD&e=CCCAGG") else {
            completionHandler(.failure(.badUrl))
            return
        }

        let priceRequest = URLRequest(url: url)
        let session = URLSession.shared
        let priceTask = session.dataTask(with: priceRequest, completionHandler: { priceData, _, error -> Void in
            if let error = error {
                completionHandler(.failure(.networkFailure(error)))
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

                completionHandler(.success(priceChange))
            } catch {
                completionHandler(.failure(.badDataFormat(error)))
            }
        })

        priceTask.resume()
    }

    // MARK: - Load chart data

    public func loadCharViewData(chartRange: ChartTimeRange,
                                 symbol: String,
                                 currency: String,
                                 completionHandler: @escaping (Result<[AnyObject], RestClientError>) -> Void) {
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
            completionHandler(.failure(.badUrl))
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, _, error -> Void in
            if let error = error {
                completionHandler(.failure(.networkFailure(error)))
                return
            }

            do {
                if let jsonData = data, let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    if let values = json["Data"] as? [AnyObject] {
                        coinsValues = values
                    }
                }

                completionHandler(.success(coinsValues))
            } catch {
                completionHandler(.failure(.badDataFormat(error)))
            }
        })

        task.resume()
    }
}
