//
//  RestClient.swift
//  vcoin
//
//  Created by Marcin Czachurski on 16.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class CoinCapClient {

    public init() {
    }

    public func loadCoins(completionHandler: @escaping (Result<[Coin], RestClientError>) -> Void) {
        guard let url = URL(string: "https://api.coincap.io/v2/assets?limit=2000") else {
            completionHandler(.failure(.badUrl))
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if let error = error {
                completionHandler(.failure(.networkFailure(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.emptyDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let coinsResult = try decoder.decode(Response<Coin>.self, from: data)

                completionHandler(.success(coinsResult.data))
            } catch let error {
                completionHandler(.failure(.badDataFormat(error)))
            }
        })

        task.resume()
    }

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
