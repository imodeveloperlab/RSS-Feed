//
//  AppDelegate.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 17.05.2021.
//

import UIKit
import BackgroundTasks
import NotificationCenter
import DSKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DSAppearance.shared.main = Appearance()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.rss.news.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        
        scheduleNextUpdate()
        
        let dataSubscriber = RSSDataSubscriber()
        
        dataSubscriber.dataDidUpdate = { _ in
            task.setTaskCompleted(success: true)
        }
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        RSSDataParser.shared.update()
    }
    
    func scheduleNextUpdate() {
        
        let request = BGAppRefreshTaskRequest(identifier: "com.rss.news.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
