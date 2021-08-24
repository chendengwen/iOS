//
//  ExDevice.swift
//  健康管理H5
//
//  Created by Cary on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//

import UIKit

extension UIDevice {
    
    // 判断是否为iPhone X 系列 -- 方式一
    class var iPhoneX: Bool {
        if SCREEN_HEIGHT == 812 || SCREEN_HEIGHT == 896 {
            return true
        }
        return false
    }
    
    // 判断是否为iPhone X 系列 -- 方式二
    public func isPhoneX() -> Bool {
        var isPhoneX = false
        if #available(iOS 11.0, *) {
            isPhoneX = UIApplication.shared.delegate?.window!?.safeAreaInsets.bottom as! CGFloat > 0.0
        }
        return isPhoneX
    }
    
}
