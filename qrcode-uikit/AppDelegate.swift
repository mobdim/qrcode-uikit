//
//  AppDelegate.swift
//  qrcode-uikit
//
//  Created by dima on 20.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window else { return false }
        
        window.backgroundColor = .systemBackground
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
                
        window.makeKeyAndVisible()
        
        if let url = launchOptions?[.url] as? URL {
            handleDeepLink(url)
        }
        
//        if let notification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
////            processNotification(notification)
//        }
//        
//        let isBackgroundLaunch = launchOptions?[.location] != nil
//                            || launchOptions?[.bluetoothCentrals] != nil
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        handleDeepLink(url)
        return true
    }
    
    private func handleDeepLink(_ url: URL) {
        appCoordinator?.handleDeepLink(url: url)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStack.shared.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.shared.saveContext()
    }
}
