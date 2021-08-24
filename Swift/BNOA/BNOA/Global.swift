//
//  Global.swift
//  BNOA
//
//  Created by Cary on 2019/11/8.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit


//MRAK: 应用默认颜色
extension UIColor {
    class var background: UIColor {
        return UIColor(r: 242, g: 242, b: 242)
    }
    
    class var theme: UIColor {
        return UIColor(r: 29, g: 221, b: 43)
    }
}

extension String {
    static let searchHistoryKey = "searchHistoryKey"
    static let sexTypeKey = "sexTypeKey"
    static let versionKey = "versionKey"
}

extension NSNotification.Name {
    static let BUserLoginStatusChanged = NSNotification.Name("BUserLoginStatusChanged")
}

enum UserLoginStatus {
    case splash
    case loginin
    case loginout
}

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

var isIphoneX: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
            || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}

//Mark: 用户信息
let account = RealmManager.sharedInstance.objects(Account.self)


