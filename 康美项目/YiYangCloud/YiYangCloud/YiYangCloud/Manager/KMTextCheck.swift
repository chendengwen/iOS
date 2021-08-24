//
//  KMTextCheck.swift
//  YiYangCloud
//
//  Created by gary on 2017/6/2.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

extension String {
    
    func isMobileNumber() -> Bool {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let CU = "^1(3[0-2|5[256]|8[56])\\d8}$"
        let CT = "^1((33|53|8[09])[0-9]|349)\\d7}$"
        
        let regextestMobile = NSPredicate.init(format: "SELF MATCHES %@", mobile)
        let regextestCM = NSPredicate.init(format: "SELF MATCHES %@", CM)
        let regextestCU = NSPredicate.init(format: "SELF MATCHES %@", CU)
        let regextestCT = NSPredicate.init(format: "SELF MATCHES %@", CT)
        
        if regextestMobile.evaluate(with: self) == true || regextestCM.evaluate(with: self) == true || regextestCU.evaluate(with: self) == true || regextestCT.evaluate(with: self) == true {
            return true
        }
        
        return false
    }
    
    func isPassWord() -> Bool {
        let password = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let regextestPassWord =  NSPredicate.init(format: "SELF MATCHES %@", password)
        
        if regextestPassWord.evaluate(with: self) {
            return true
        }
        
        return false
    }
}
