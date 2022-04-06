//
//  SceneDelegate.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 17.05.2021.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        // Update rss feed
        RSSDataParser.shared.update()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        let request = BGAppRefreshTaskRequest(identifier: "com.rss.news.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
        
        let content = UNMutableNotificationContent()
        content.subtitle = "Articles have been updated"
        content.sound = UNNotificationSound.default
        
        // Trigger new update in next 24 hours after app did enter in background
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24, repeats: false)
        
        // Choose a random identifier
        let notificationsRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add our notification request
        UNUserNotificationCenter.current().add(notificationsRequest)
    }
}

