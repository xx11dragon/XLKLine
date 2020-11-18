//
//  AppDelegate.swift
//  XLKLineExample
//
//  Created by xx11dragon on 2020/5/7.
//  Copyright © 2020 xx11dragon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }

}

