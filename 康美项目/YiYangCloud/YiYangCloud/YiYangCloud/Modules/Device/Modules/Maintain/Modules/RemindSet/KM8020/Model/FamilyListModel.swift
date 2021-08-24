//
//  FamilyListModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/19.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class FamilyListModelContent: NSObject {
    var phone:String?
    var nickName:String?
    var sex:String?
    var shareLocation:String?
    var memberIdNo:String?
    var memberId:String?
    var lastDate:String?
}

class FamilyListModel: NSObject {
    var content = [FamilyListModelContent]()
    var errorCode:Int?
    var msg:String?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["content":FamilyListModelContent.self,]
    }
}
