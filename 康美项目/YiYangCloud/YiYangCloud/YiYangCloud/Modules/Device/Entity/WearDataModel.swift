//
//  WearModel.swift
//  YiYangCloud
//
//  Created by zhong on 2017/5/10.
//  Copyright © 2017年 gary. All rights reserved.
//
import UIKit

class WearDataMember: NSObject {
    var createdate:String?
    var memberAccount:String?
    var memberId:Int?
    var memberIdNo:Int?
    var memberMail:String?
    var memberMobile:String?
    var memberQq:String?
    var memberWechat:String?
    var updatedate:String?
}

class WearDataDeviceMember: NSObject {
    var accept:String?
    var createdTime:String?
    var deviceId:String?
    var deviceIds:String?
    var managedByFollower:String?
    var memberId:String?
    var updateTime:String?
}

class WearDataDevice: NSObject {
    var color:String?
    var createdTime:String?
    var deviceBatch:String?
    var deviceGroupId:String?
    var deviceId:Int? = 0
    var deviceVerify:String?
    var enable:String?
    var imei:String?
    var productCode:String?
    var serialNumber:String?
    var type:String?
    var updateTime:String?
}

class WearDataContent: NSObject {
    var member = [WearDataMember]()
    var deviceMember = [WearDataDeviceMember]()
    var device = [WearDataDevice]()
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "member":WearDataMember.self,
            "deviceMember":WearDataDeviceMember.self,
            "device":WearDataDevice.self]
    }
}

class WearDataModel: NSObject {
    var content:WearDataContent?
    var errorCode:Int?
    var msg:String?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["content":WearDataContent.self,]
    }
}


