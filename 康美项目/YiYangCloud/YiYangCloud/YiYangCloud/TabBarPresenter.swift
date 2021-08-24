//
//  TabBarPresenter.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/28.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class TabBarPresenter: BasePresenter {

    override func getInterface() -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: (StoryBoardNames.main?.rawValue)!, bundle: Bundle.main)
        let tabBarCtl:TabBarController = storyboard.instantiateInitialViewController() as! TabBarController
        
        tabBarCtl.presenter = self
        return tabBarCtl
    }
    
    deinit {
        print("deinit -- TabBarPresenter")
    }
}

extension TabBarPresenter: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}


// MARK: 需要做自定义UITabBarController时使用这个类 如：红点、监听UITabBar
class TabBarController: UITabBarController {
    
    // MARK: 此时代理不使用 weak 属性，防止presenter被释放
    var presenter:AnyObject?
    
    // MARK: 需要记录tabBarItem时使用
    /*
     var lastItem:UITabBarItem?
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 在自定义类内部设置了代理，UITabBarControllerDelegate的代理方法才会执行
        self.delegate = self.presenter as? UITabBarControllerDelegate
        
        // 检查版本
        KMVersionInteractor.checkVersion(success: { (update, version) in
            if update {
                
            }
        }) { (message) in
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    // MARK: - UITabBarDelegate
    /*
     override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        lastItem = item
     }
     */
    
    deinit {
        print("deinit -- TabBarController")
    }
    
}

