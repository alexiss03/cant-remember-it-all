//
//  AppDelegate.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var applicationCoordinator: ApplicationCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        _ =  PNSharedRealm.configureDefaultRealm()
        
        navigationBarCustomization()
        makeCoordinator()
        return true
    }
    
    private func makeCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            print("Window is nil")
            return
        }

        applicationCoordinator = ApplicationCoordinator.init(window: window, services: Services.init())
        applicationCoordinator?.start()
    }
    
    private func navigationBarCustomization() {
        UINavigationBar.appearance().setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        
        UINavigationBar.appearance().shadowImage = UIImage()

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
