//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    
import Foundation

public class PricesService: ObservableObject {
    public static let shared = PricesService()

    var urlSession: URLSession?
    var webSocketTask: URLSessionWebSocketTask?
    var pricesServiceConnection = PricesServiceConnection()
    
    deinit {
        self.stop()
    }
    
    func start() {
        guard self.pricesServiceConnection.isConnected == false else {
            return
        }
        
        let favouritesHandler = FavouritesHandler()
        let favourites = favouritesHandler.getFavourites()
        
        guard favourites.isEmpty == false else {
            return
        }
        
        let queryParam = favourites.map { favourite in favourite.coinId }.joined(separator: ",")
        
        self.urlSession = URLSession(configuration: .default, delegate: self.pricesServiceConnection, delegateQueue: OperationQueue())
        self.webSocketTask = self.urlSession?.webSocketTask(with: URL(string: "wss://ws.coincap.io/prices?assets=\(queryParam)")!)
        
        self.webSocketTask?.resume()
        self.receiveMessages()
    }
    
    func stop() {
        self.webSocketTask?.cancel(with: .goingAway, reason: nil)
        self.webSocketTask = nil
        self.urlSession = nil
    }
    
    private func receiveMessages() {
        webSocketTask?.receive { result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self.updatePrice(message: text)
                case .data(_):
                    print("Received unsupported message")
                @unknown default:
                    print("Received unknown")
                }
      
                self.receiveMessages()
            }
        }
    }
    
    private func updatePrice(message: String) {
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        guard let prices = try? JSONDecoder().decode(([String: String]).self, from: data) else {
            return
        }

        for price in prices {
            guard let coin = ApplicationStateService.shared.coins.first(where: { coinViewModel in coinViewModel.id == price.key }) else {
                continue
            }
            
            guard let priceUsd = Double(price.value) else {
                continue
            }
            
            DispatchQueue.runOnMain {
                coin.changePercent24Hr = (priceUsd * coin.changePercent24Hr) / coin.priceUsd
                coin.price = priceUsd / ApplicationStateService.shared.currencyRateUsd
                coin.priceUsd = priceUsd
            }
        }
    }
}

class PricesServiceConnection: NSObject, URLSessionWebSocketDelegate {
    var isConnected = false
    var connectionError = false
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.isConnected = true
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.isConnected = false
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError: Error?) {
        self.connectionError = true
    }
}
