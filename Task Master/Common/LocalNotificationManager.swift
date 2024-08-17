//
//  LocalNotificationManager.swift
//  Task Master
//
//  Created by Rahul Anand on 07/08/24.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = LocalNotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Request permission for notifications
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Request Authorization Failed: \(error.localizedDescription)")
            } else {
                print("Notification Permission Granted: \(granted)")
            }
        }
    }
    
    // Schedule a notification
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    // Remove a scheduled notification
    func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // Remove all pending notifications
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .badge, .sound])
    }
    
    // Handle notification actions or responses
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification action or response
        print("Notification received with identifier: \(response.notification.request.identifier)")
        self.handleNotificationTap()
        completionHandler()
    }
    
    func handleNotificationTap() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first {
                if let navigationController = window.rootViewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: true)
                } else {
                    print("NavigationController not found")
                }
            }
        }
    }
}
