//
//  VirtualCoinApp.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 17/04/2021.
//

import SwiftUI
import VirtualCoinKit
import BackgroundTasks

@main
struct VirtualCoinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    appDelegate.submitBackgroundTasks()
                }
                .environmentObject(ApplicationStateService.shared)
                .environmentObject(CoinsService.shared)
                .environment(\.managedObjectContext, CoreDataHandler.shared.container.viewContext)
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
            
            task.expirationHandler = {
                print("Task expired")
                task.setTaskCompleted(success: false)
            }
            
            print("Refreshing app in background. Time remaining: \(UIApplication.shared.backgroundTimeRemaining) s")
            
            print("Networking...")
                task.setTaskCompleted(success: true)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.submitBackgroundTasks()
    }
    
    func submitBackgroundTasks() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: backgroundTaskId)
            request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Refresh after 5 minutes.
            try BGTaskScheduler.shared.submit(request)

            print("Submitted background task")
        } catch {
            print("Could not schedule app refresh task \(error.localizedDescription)")
        }
    }
}
