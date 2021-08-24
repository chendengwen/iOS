//
//  KM8020DialSetModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/24.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class KM8020DialSetList:NSObject {
    var imei:String?
    var sos1:String?
    var sos2:String?
    var sos3:String?
    var sosname1:String?
    var sosSms:String?
    var fmy1:String?
    var fmy2:String?
    var fmy3:String?
    var fmy4:String?
    var updatedate:Int?
    var createdate:Int?
}

class KM8020DialSetContent:NSObject {
    var list = [KM8020DialSetList]()
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "list":KM8020DialSetList.self]
    }

}

class KM8020DialSetModel: NSObject {
    var errorCode:Int?
    var msg:String?
    var content:KM8020DialSetContent?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "content":KM8020DialSetContent.self]
    }
}
