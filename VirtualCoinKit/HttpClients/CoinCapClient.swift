//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public class CoinCapClient {

    public init() {
    }
    
    public func getCoinsAsync(completionHandler: @escaping (Result<[Coin], RestClientError>) -> Void) {
        let url = "https://api.coincap.io/v2/assets?limit=2000"
        self.downloadAsync(from: url, completionHandler: completionHandler)
    }

    public func getCoinAsync(for coinId: String,
                             completionHandler: @escaping (Result<Coin, RestClientError>) -> Void) {
        let url = "https://api.coincap.io/v2/assets/\(coinId)"
        self.downloadAsync(from: url, completionHandler: completionHandler)
    }
    
    public func getChartValuesAsync(for coinId: String,
                                    withRange chartRange: ChartTimeRange,
                                    completionHandler: @escaping (Result<[ChartValue], RestClientError>) -> Void) {
        let url = self.getChartApiUrl(for: coinId, withRange: chartRange)
        self.downloadAsync(from: url, completionHandler: completionHandler)
    }
    
    public func getMarketValuesAsync(for coinId: String,
                                     completionHandler: @escaping (Result<[Market], RestClientError>) -> Void) {
        let url = "https://api.coincap.io/v2/assets/\(coinId)/markets"
        self.downloadAsync(from: url, completionHandler: completionHandler)
    }
    
    public func getCurrencyRate(for currencyId: String,
                                completionHandler: @escaping (Result<CurrencyRate, RestClientError>) -> Void) {
        let url = "https://api.coincap.io/v2/rates/\(currencyId)"
        self.downloadAsync(from: url, completionHandler: completionHandler)
    }
    
    public func getCoinPriceAsync(for coinId: String,
                                  currencyId: String,
                                  completionHandler: @escaping (Result<Double, RestClientError>) -> Void) {

        self.getCurrencyRate(for: currencyId) { currencyResult in
            
            switch currencyResult {
            case .success(let currencyRate):
                let url = "https://api.coincap.io/v2/assets/\(coinId)"
                self.downloadAsync(from: url) { (coinResult: Result<Coin, RestClientError>) in
                    switch coinResult {
                    case .success(let coin):
                        
                        guard let priceUsdString = coin.priceUsd, let priceUsd = Double(priceUsdString), let rateUsd = Double(currencyRate.rateUsd) else {
                            completionHandler(Result.failure(RestClientError.numberBadFormat))
                            return
                        }
                        
                        let value = priceUsd / rateUsd
                        completionHandler(Result.success(value))
                        break
                    case .failure(let error):
                        completionHandler(Result.failure(error))
                        break
                    }
                }
                break
            case.failure(let error):
                completionHandler(Result.failure(error))
                break
            }
        }
    }
    
    private func getChartApiUrl(for coinId: String,
                                withRange chartRange: ChartTimeRange) -> String {
        switch chartRange {
        case .hour:
            let now = Date()
            let start = Calendar.current.date(byAdding: .hour, value: -1, to: now)?.unixTimestamp
            let end = now.unixTimestamp
            return "https://api.coincap.io/v2/assets/\(coinId)/history?interval=m1&start=\(start!)&end=\(end)"
        case .day:
            let now = Date()
            let start = Calendar.current.date(byAdding: .day, value: -1, to: now)?.unixTimestamp
            let end = now.unixTimestamp
            return "https://api.coincap.io/v2/assets/\(coinId)/history?interval=m5&start=\(start!)&end=\(end)"
        case .week:
            let now = Date()
            let start = Calendar.current.date(byAdding: .day, value: -7, to: now)?.unixTimestamp
            let end = now.unixTimestamp
            return "https://api.coincap.io/v2/assets/\(coinId)/history?interval=h2&start=\(start!)&end=\(end)"
        case .month:
            let now = Date()
            let start = Calendar.current.date(byAdding: .day, value: -30, to: now)?.unixTimestamp
            let end = now.unixTimestamp
            return "https://api.coincap.io/v2/assets/\(coinId)/history?interval=h12&start=\(start!)&end=\(end)"
        case .year:
            let now = Date()
            let start = Calendar.current.date(byAdding: .day, value: -365, to: now)?.unixTimestamp
            let end = now.unixTimestamp
            return "https://api.coincap.io/v2/assets/\(coinId)/history?interval=d1&start=\(start!)&end=\(end)"
        }
    }
    
    private func downloadAsync<T: Decodable>(from url: String,
                                             completionHandler: @escaping (Result<T, RestClientError>) -> Void) {
        guard let url = URL(string: url) else {
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
                let coinsResult = try decoder.decode(Response<T>.self, from: data)

                completionHandler(.success(coinsResult.data))
            } catch let error {
                completionHandler(.failure(.badDataFormat(error)))
            }
        })

        task.resume()
    }
}
