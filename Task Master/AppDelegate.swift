//
//  AppDelegate.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocalNotificationManager.shared.requestNotificationPermission()
        if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            _ = handleShortcutItem(shortcutItem)
            return false
        }
        return true
    }
    
    // Mark: Shortcut
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handled = handleShortcutItem(shortcutItem)
        completionHandler(handled)
    }
    
    private func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let shortcutType = shortcutItem.type as String? else { return false }
        
        switch shortcutType {
        case "Rahul-Anand.Task-Master":
            if let rootViewController = window?.rootViewController as? UINavigationController,
               let taskListVC = rootViewController.viewControllers.first as? TaskListViewController {
                // Here you can navigate to the Add Task screen
                let addTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddAndEditTaskViewController
                addTaskViewController.setNavigationItemsTitle(navigationTitle: "Add Tasks")
                rootViewController.pushViewController(addTaskViewController, animated: true)
                return true
            }
        default:
            return false
        }
        return false
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

