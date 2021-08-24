//
//  AppDelegate.swift
//  H5演示Demo
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019 Gary. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.absoluteString.contains("a1.kmwlyy.com") || url.absoluteString.contains("kmjkgl.com") {
            NotificationCenter.default.post(name: NSNotification.Name.Notification_PaySuccess, object: nil)
        }
        return true
    }


}

