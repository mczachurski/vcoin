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
    
    public func sendNotification() {
        let alerts = self.alertsHandler.getAlerts()
        for alert in alerts {
            self.restClient.loadCoinPrice(symbol: alert.coinSymbol!, currency: alert.currency!, market: alert.marketCode!, callback: { (price) in
                
                if price == nil {
                    return
                }
                
                if alert.isPriceLower && price! < alert.price {
                    
                    let center = UNUserNotificationCenter.current()
                    center.getNotificationSettings { (settings) in
                        if settings.authorizationStatus == .authorized {
                            self.sendNotification(center: center, title: alert.coinSymbol!, body: "Currency price is \(price!.toFormattedPrice(currency: alert.currency!)) lower then: \(alert.price.toFormattedPrice(currency: alert.currency!))")
                        }
                    }
                }
                else if !alert.isPriceLower && price! > alert.price {
                    
                    let center = UNUserNotificationCenter.current()
                    center.getNotificationSettings { (settings) in
                        if settings.authorizationStatus == .authorized {
                            self.sendNotification(center: center, title: alert.coinSymbol!, body: "Currency price is \(price!.toFormattedPrice(currency: alert.currency!)) higher then: \(alert.price.toFormattedPrice(currency: alert.currency!))")
                        }
                    }
                }
            })
        }
    }
    
    private func sendNotification(center: UNUserNotificationCenter, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        
        let identifier = "VCoinLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error during sending notification \(error)")
            }
        })
    }
}
