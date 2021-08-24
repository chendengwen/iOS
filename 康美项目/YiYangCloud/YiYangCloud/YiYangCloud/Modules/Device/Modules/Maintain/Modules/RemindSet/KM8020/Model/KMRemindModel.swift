//
//  KMRemindModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/19.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class KMRemindModel: NSObject {
    var errorCode:Int?
    var msg:String?
    var content:KMRemindModelContent?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "content":KMRemindModelContent.self]
    }
}

class KMRemindModelContent: NSObject {
    var list = [KMRemindDetailModel]()
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "list":KMRemindDetailModel.self]
    }
}

class KMRemindDetailModel: NSObject {
    var id:Int?
    var imei:String?
    var team:String?
    var type:String?
    var isvaild:String?
    var remindTime:String?
    var updated:Int?
    var remindText:String?
    var mon:String?
    var tue:String?
    var wed:String?
    var thu:String?
    var fri:String?
    var sat:String?
    var sun:String?
    var updateDate:Int?
    var createDate:Int?
}
