//
//  Notifications.swift
//  VCoin
//
//  Created by Marcin Czachurski on 03.02.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UserNotifications
import VCoinKit

class Notifications {
    private let alertsHandler = AlertsHandler()
    private let restClient = RestClient()
    private var priceAlerts: [String: PriceAlert] = [:]

    func sendNotification() {
        let alerts = self.alertsHandler.getActiveAlerts()

        for alert in alerts {
            let alertKey = self.getKey(alert: alert)
            if priceAlerts[alertKey] == nil {
                priceAlerts[alertKey] = PriceAlert(currency: alert.currency,
                                                   markedCode: alert.marketCode,
                                                   coinSymbol: alert.coinSymbol)
            }
        }

        let lock = NSLock()

        for priceAlert in priceAlerts {
            priceAlert.value.processing = Processing.processing

            self.restClient.loadCoinPrice(symbol: priceAlert.value.coinSymbol,
                                          currency: priceAlert.value.currency,
                                          market: priceAlert.value.marketCode) { result in
                switch result {
                case .success(let price):
                    lock.lock()

                    priceAlert.value.price = price
                    priceAlert.value.processing = Processing.finished
                    if self.allAlertsFinished() {
                        self.processAlerts(alerts: alerts)
                    }

                    lock.unlock()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func allAlertsFinished() -> Bool {
        let notFinishedAlerts = priceAlerts.filter { _, value -> Bool in
            return value.processing != Processing.finished
        }

        return notFinishedAlerts.isEmpty
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
            let body = "Currency price is \(price.toFormattedPrice(currency: alert.currency)) lower then: \(alert.price.toFormattedPrice(currency: alert.currency))"

            self.sendNotification(center: center,
                                  title: alert.coinSymbol,
                                  body: body)

            alert.alertSentDate = Date()
            CoreDataHandler.shared.saveContext()
        }
    }

    private func notifyAboutHigherPrices(settings: UNNotificationSettings, center: UNUserNotificationCenter, alert: Alert, price: Double) {
        if settings.authorizationStatus == .authorized {
            let body = "Currency price is \(price.toFormattedPrice(currency: alert.currency)) higher then: \(alert.price.toFormattedPrice(currency: alert.currency))"

            self.sendNotification(center: center,
                                  title: alert.coinSymbol,
                                  body: body)

            alert.alertSentDate = Date()
            CoreDataHandler.shared.saveContext()
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
        return self.getKey(currency: alert.currency, markedCode: alert.marketCode, coinSymbol: alert.coinSymbol)
    }

    private func getKey(currency: String, markedCode: String, coinSymbol: String) -> String {
        return "\(currency)|\(markedCode)|\(coinSymbol)"
    }
}
