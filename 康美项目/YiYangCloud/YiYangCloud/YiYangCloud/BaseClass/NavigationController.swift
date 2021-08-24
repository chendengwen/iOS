//
//  NavigationController.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/9.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
}


extension NavigationController:UINavigationControllerDelegate {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
}
