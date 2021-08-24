//
//  KM8000DialSetModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class KM8000DialSetList:NSObject {
    var imei:String?
    var sosPhoneNo1:String?
    var sosPhoneNo2:String?
    var sosPhoneNo3:String?
    var fallPhoneNo1:String?
    var fallPhoneNo2:String?
    var fallPhoneNo3:String?
    var fmlyPhoneNo1:String?
    var fmlyPhoneNo2:String?
    var fmlyPhoneNo3:String?
    var nonDistrub:String?
    var fallDetect:String?
    var uHeight:String?
    var uWeight:String?
    var uStep:String?
    var echoPrT:String?
    var echoGpsT:String?
    var phoneLimitTime:String?
    var phoneLimitOnoff:String?
    var autoread:String?
    var myWear:String?
}

class KM8000DialSetContent: NSObject {
    var list = [KM8000DialSetList]()
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "list":KM8000DialSetList.self]
    }
}

class KM8000DialSetModel: NSObject {
    var errorCode:Int?
    var msg:String?
    var content:KM8000DialSetContent?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "content":KM8000DialSetContent.self]
    }
}
