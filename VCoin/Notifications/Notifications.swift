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
    private var priceAlerts: [String:PriceAlert] = [:]
    
    public func sendNotification() {
        let alerts = self.alertsHandler.getActiveAlerts()
        
        for alert in alerts {
            let alertKey = self.getKey(alert: alert)
            if priceAlerts[alertKey] == nil {
                priceAlerts[alertKey] = PriceAlert(currency: alert.currency!, markedCode: alert.marketCode!, coinSymbol: alert.coinSymbol!)
            }
        }
        
        let lock = NSLock()
        
        for priceAlert in priceAlerts {
            priceAlert.value.processing = Processing.Processing
            
            
            self.restClient.loadCoinPrice(symbol: priceAlert.value.coinSymbol, currency: priceAlert.value.currency, market: priceAlert.value.marketCode, callback: { (price) in
                
                lock.lock()
                
                priceAlert.value.price = price
                priceAlert.value.processing = Processing.Finished
                if self.allAlertsFinished() {
                    self.processAlerts(alerts: alerts)
                }
                
                lock.unlock()
            })
        }
    }
    
    private func allAlertsFinished() -> Bool {
        for priceAlert in priceAlerts {
            if priceAlert.value.processing != Processing.Finished {
                return false
            }
        }
        
        return true
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
        if price == nil {
            return
        }
                
        if alert.isPriceLower && price! < alert.price {
            
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    self.sendNotification(center: center, title: alert.coinSymbol!, body: "Currency price is \(price!.toFormattedPrice(currency: alert.currency!)) lower then: \(alert.price.toFormattedPrice(currency: alert.currency!))")
                    
                    alert.alertSentDate = Date()
                    CoreDataHandler.shared.saveContext()
                }
            }
        }
        else if !alert.isPriceLower && price! > alert.price {
            
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    self.sendNotification(center: center, title: alert.coinSymbol!, body: "Currency price is \(price!.toFormattedPrice(currency: alert.currency!)) higher then: \(alert.price.toFormattedPrice(currency: alert.currency!))")
                    
                    alert.alertSentDate = Date()
                    CoreDataHandler.shared.saveContext()
                }
            }
        }
    }
    
    private func sendNotification(center: UNUserNotificationCenter, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let identifier = "VCoinLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error during sending notification \(error)")
            }
        })
    }
    
    private func getKey(alert: Alert) -> String {
        return self.getKey(currency: alert.currency!, markedCode: alert.marketCode!, coinSymbol: alert.coinSymbol!)
    }
    
    private func getKey(currency: String, markedCode: String, coinSymbol: String) -> String {
        return "\(currency)|\(markedCode)|\(coinSymbol)"
    }
}
