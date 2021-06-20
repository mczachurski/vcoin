//
//  VirtualCoinApp.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 17/04/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import SwiftUI
import VirtualCoinKit
import BackgroundTasks
import URLImage
import URLImageStore

@main
struct VirtualCoinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let urlImageService = URLImageService(inMemoryStore: URLImageInMemoryStore())

    var body: some Scene {
        WindowGroup {
            AppView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    PricesService.shared.stop()
                    appDelegate.submitBackgroundTasks()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    PricesService.shared.start()
                }
                .environmentObject(ApplicationStateService.shared)
                .environmentObject(PricesService.shared)
                .environmentObject(CoinsService.shared)
                .environment(\.managedObjectContext, CoreDataHandler.shared.container.viewContext)
                .environment(\.urlImageService, urlImageService)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let backgroundTaskId = "dev.mczachurski.vcoin.fetch"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.registerBackgroundFetch()
        return true
    }
    
    private func registerBackgroundFetch() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskId, using: nil) { task in
            
            // Task expired.
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            
            let notifications = Notifications()
            notifications.sendNotification { result in
                switch result {
                case .success:
                    task.setTaskCompleted(success: true)
                case .failure(_):
                    task.setTaskCompleted(success: false)
                }
            }
        }
    }
    
    func submitBackgroundTasks() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: backgroundTaskId)
            request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // Refresh after 1 hour.
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh task \(error.localizedDescription)")
        }
    }
}
