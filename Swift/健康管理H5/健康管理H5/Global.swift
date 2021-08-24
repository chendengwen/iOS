//
//  Global.swift
//  H5演示Demo
//
//  Created by mac on 2019/7/29.
//  Copyright © 2019 Gary. All rights reserved.
//
import UIKit


// 屏幕宽度与高度
let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.height

// 导航栏高度
let NavHeight:CGFloat = UIDevice.iPhoneX ? 70.0 : 64.0

//tabbar高度
let TabHeight:CGFloat = UIDevice.iPhoneX ? (49 + 34) : 49

//合法的URL内容（商城加密后的参数需要过滤非法字符）
let URL_Legal_Char_Set = "01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#"

//简写 - UserDefaults
let UD = UserDefaults.standard

//获取包内文件完整路径
func BoundFilePath(_ path:String) -> String {
    return Bundle.main.resourcePath! + path
}
