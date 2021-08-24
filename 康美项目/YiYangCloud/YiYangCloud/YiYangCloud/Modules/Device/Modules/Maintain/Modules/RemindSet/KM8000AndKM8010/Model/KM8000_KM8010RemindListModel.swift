//
//  KM8000_KM8010RemindListModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class KM8000_KM8010RemindListModel: NSObject {
    var errorCode:Int?
    var msg:String?
    var content:KM8000_KM8010RemindListContent?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "content":KM8000_KM8010RemindListContent.self]
    }
}

class KM8000_KM8010RemindListContent:NSObject {
    var list = [KM8000_KM8010RemindList]()
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "list":KM8000_KM8010RemindList.self]
    }
}

class KM8000_KM8010RemindList:NSObject {
    var sId:String?
    var sImei:String?
    var isvalid:String?
    var sYear:String?
    var sMon:String?
    var sDay:String?
    var sHour:String?
    var sMin:String?
    var sAmpm:String?
    var sType:String?
    var sUpdatedate:String?
    var updated:String?
    var attribute1:String?
    var t1Hex:String?
    var t2Hex:String?
    var t3Hex:String?
    var t4Hex:String?
    var t5Hex:String?
    var t6Hex:String?
    var t7Hex:String?
}
