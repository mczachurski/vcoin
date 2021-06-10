//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import UserNotifications
import VirtualCoinKit

class Notifications {
    private let alertsHandler = AlertsHandler()
    private let coinCapClient = CoinCapClient()
    private var priceAlerts: [String: PriceAlert] = [:]

    func sendNotification(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let alerts = self.alertsHandler.getActiveAlerts()

        for alert in alerts {
            let alertKey = self.getKey(alert: alert)
            if priceAlerts[alertKey] == nil {
                priceAlerts[alertKey] = PriceAlert(currency: alert.currency,
                                                   coinId: alert.coinId)
            }
        }

        let notificationsGroup = DispatchGroup()

        for priceAlert in priceAlerts {
            notificationsGroup.enter()
            priceAlert.value.processing = Processing.processing

            guard let currency = Currencies.allCurrenciesDictionary[priceAlert.value.currency] else {
                completionHandler(Result.failure(NotificationsError.notRecognizedCurrencySymbol))
                return
            }
            
            self.coinCapClient.getCoinPriceAsync(for: priceAlert.value.coinId, currencyId: currency.id) { result in
                switch result {
                case .success(let price):
                    priceAlert.value.price = price
                    priceAlert.value.processing = Processing.finished
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                notificationsGroup.leave()
            }
        }
        
        notificationsGroup.notify(queue: .main) {
            self.processAlerts(alerts: alerts)
            completionHandler(Result.success(()))
        }
    }

    private func processAlerts(alerts: [Alert]) {
        for alert in alerts {
            let alertKey = self.getKey(alert: alert)
            if let priceAlert = priceAlerts[alertKey] {
                self.processAlert(alert: alert, price: priceAlert.price)
            }
        }
    }

    private func processAlert(alert: Alert, price: Double?) {
        guard let price = price else {
            return
        }

        if alert.isPriceLower && price < alert.price {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                self.notifyAboutLowerPrices(settings: settings, center: center, alert: alert, price: price)
            }
        } else if !alert.isPriceLower && price > alert.price {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                self.notifyAboutHigherPrices(settings: settings, center: center, alert: alert, price: price)
            }
        }
    }

    private func notifyAboutLowerPrices(settings: UNNotificationSettings, center: UNUserNotificationCenter, alert: Alert, price: Double) {
        if settings.authorizationStatus == .authorized {
            let body = "Currency price is \(price.toFormattedPrice(currency: alert.currency)) lower than: \(alert.price.toFormattedPrice(currency: alert.currency))"

            self.sendNotification(center: center,
                                  title: alert.coinSymbol,
                                  body: body)

            alert.alertSentDate = Date()
            CoreDataHandler.shared.save()
        }
    }

    private func notifyAboutHigherPrices(settings: UNNotificationSettings, center: UNUserNotificationCenter, alert: Alert, price: Double) {
        if settings.authorizationStatus == .authorized {
            let body = "Currency price is \(price.toFormattedPrice(currency: alert.currency)) higher than: \(alert.price.toFormattedPrice(currency: alert.currency))"

            self.sendNotification(center: center,
                                  title: alert.coinSymbol,
                                  body: body)

            alert.alertSentDate = Date()
            CoreDataHandler.shared.save()
        }
    }

    private func sendNotification(center: UNUserNotificationCenter, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let identifier = "VCoinLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error during sending notification \(error)")
            }
        })
    }

    private func getKey(alert: Alert) -> String {
        return self.getKey(currency: alert.currency, coinId: alert.coinId)
    }

    private func getKey(currency: String, coinId: String) -> String {
        return "\(currency)|\(coinId)"
    }
}
