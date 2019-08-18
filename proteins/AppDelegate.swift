//
//  AppDelegate.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/2/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var blockRotation = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureNavigationBarAppearance()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Release shared resources, save user data, invalidate timers
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Reset to home view controller when app enters foreground
        resetToHomeViewController()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused while the application was inactive
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Save data if appropriate
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    private func resetToHomeViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {
            return
        }
        
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.isTranslucent = false
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Orientation Control
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return blockRotation ? .portrait : .all
    }
}

