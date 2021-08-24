//
//  AppDelegate.swift
//  BNOA
//
//  Created by Cary on 2019/11/8.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var reachability : NetworkReachabilityManager? = {
        return NetworkReachabilityManager.init(host: "http://app.u17.com")
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configBase()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let infoDictionary: [String : Any] = Bundle.main.infoDictionary!
        let currentVersion = infoDictionary["CFBundleShortVersionString"] as! String
        let savedVersion = UserDefaults.standard.value(forKey: String.versionKey) as? String ?? ""
        if currentVersion.compare(savedVersion) == .orderedSame  {
            window?.rootViewController = rootViewController()
        } else {
            window?.rootViewController = SplashViewController()
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func configBase() {
        //Mark: 键盘控制
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //Mark: 网络监听
        reachability?.listener = { status in
            switch status {
            case .reachable(.wwan):
                BNoticeBar.init(config: BNoticeBarConfig(title: "检测到您正在使用移动数据")).show(duration: 2)
            default:
                print("网络变化")
                break
            }
        }
        reachability?.startListening()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userStatusChanged), name: .BUserLoginStatusChanged, object: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @objc func userStatusChanged(noticeInfo:Notification) {
//        Logger.log(items: noticeInfo)
        window?.rootViewController = rootViewController()
    }

    func rootViewController() -> UIViewController {
        if account.count > 0 {
            return BTabBarController()
        } else {
            let nav = BNavigationController.init(rootViewController: LoginViewController())
            return nav
        }
    }
}

