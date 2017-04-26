//
//  AppDelegate.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import Swinject
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        showInitialViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
}

extension AppDelegate {
    func showInitialViewController () {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
            print("Notes Feed View Controller is nil")
            return
        }
        
        guard let unwrappedSideMenuViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNSideMenuViewController") as? PNSideMenuViewController else {
            print("Side Menu View Controller is nil")
            return
        }

        let slideMenuController = SlideMenuController(mainViewController:unwrappedMainViewController, leftMenuViewController: unwrappedSideMenuViewController)
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewDrag = true
        
        UIApplication.shared.windows.first?.rootViewController = slideMenuController
    }
}
