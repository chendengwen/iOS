//
//  BSRangeModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/25.
//  Copyright © 2017年 gary. All rights reserved.
//

class BSRangeModelContent: NSObject {
    var afterMealH:String?
    var afterMealL:String?
    var beforeBedH:String?
    var beforeBedL:String?
    var beforeMealL:String?
    var beforeMealH:String?
    
    var dinnerT:String?
    var lunchT:String?
    
    var createDate:String?
    var updateDate:String?
    var memberId:String?
    
}

class BSRangeModel: NSObject {
    var errorCode:Int?
    var msg:String?
    var content:BSRangeModelContent?
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return [
            "content":BSRangeModelContent.self]
    }
}
