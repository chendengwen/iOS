//
//  KMNavigationBar.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/27.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

private var kNavBarBgAlphaKey: String = "navBarBgAlphaKey"
public extension UIViewController {

    var navBarBgAlpha: String? {
        get {
//            return (objc_getAssociatedObject(self, &kNavBarBgAlphaKey) as? String)
            let alpha = (objc_getAssociatedObject(self, &kNavBarBgAlphaKey) as? String)
            if alpha == nil {
                return "1.0"
            }
            return alpha
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kNavBarBgAlphaKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
            // 设置导航栏透明度（利用Category自己添加的方法）
//            [self.navigationController setNeedsNavigationBackground:[navBarBgAlpha floatValue]];
            self.navigationController?.setNeedsNavigationBackground(CGFloat(Float(navBarBgAlpha!)!))
        }
    }
    
}

private var kCloudoxKey: String = "CloudoxKey"
public extension UINavigationController {
    
    var cloudox: String? {
        get { return (objc_getAssociatedObject(self, &kCloudoxKey) as? String) }
        set(newValue) {
            objc_setAssociatedObject(self, &kCloudoxKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    func setNeedsNavigationBackground(_ alpha:CGFloat) {
        // 导航栏背景透明度设置
        let barBackgroundView = self.navigationBar.subviews.first
        let backgroundImageView = barBackgroundView?.subviews.first as? UIImageView
        if self.navigationBar.isTranslucent {
            if backgroundImageView != nil && backgroundImageView?.image != nil {
                barBackgroundView?.alpha = CGFloat(alpha)
            } else {
                let backgroundEffectView = barBackgroundView?.subviews[1]
                if backgroundEffectView != nil {
                    backgroundEffectView?.alpha = CGFloat(alpha)
                }
            }
        } else {
            barBackgroundView?.alpha = CGFloat(alpha)
        }
        
        // 对导航栏下面那条线做处理
        self.navigationBar.clipsToBounds = alpha == 0.0
    }
    
}
