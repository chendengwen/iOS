//
//  UserInfoModel.swift
//  健康管理H5
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//

/**
 待完善
 1.线程读取安全问题
 2.数据双向绑定
 */

import UIKit

struct UserInfoModel {
    
    private(set) var phone : String?
    private(set) var uid_360App: String?
    private(set) var uid_H5: String?
    private(set) var token_360App: String?
    private(set) var token_H5: String?
    
    static var shareCache = UserInfoModel()
    
    private init(){}
    
    mutating func update(phone:String = "",
                uid_360App:String = "",
                uid_H5:String = "",
                token_360App:String = "",
                token_H5:String = "") {
        self.phone = phone
        self.uid_H5 = uid_H5
        self.uid_360App = uid_360App
        self.token_H5 = token_H5
        self.token_360App = token_360App
    }
    
    mutating func update(with dictionary:Dictionary<String,Any>) {
        self.phone = "\(dictionary["phone"] ?? "")"
        self.uid_H5 = "\(dictionary["uid_H5"] ?? "")"
        self.uid_360App = "\(dictionary["uid_360App"] ?? "")"
        self.token_H5 = "\(dictionary["token_H5"] ?? "")"
        self.token_360App = "\(dictionary["token_360App"] ?? "")"
    }
}
