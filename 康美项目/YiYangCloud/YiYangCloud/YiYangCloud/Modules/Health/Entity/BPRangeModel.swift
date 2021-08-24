//
//  BPRangeModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/24.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class BPRangeModelContent: NSObject {
    var bpdH:String?
    var bpdL:String?
    var bpsL:String?
    var bpsH:String?
    var plusH:String?
    var plusL:String?
    
    var createDate:String?
    var updateDate:String?
    var memberId:String?

}

class BPRangeModel: NSObject {
    var errorCode:Int?
    var msg:String?
    var content:BPRangeModelContent?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "content":BPRangeModelContent.self]
    }
}
