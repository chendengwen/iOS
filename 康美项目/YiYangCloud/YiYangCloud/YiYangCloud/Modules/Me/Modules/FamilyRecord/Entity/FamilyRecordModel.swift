//
//  FamilyRecordModel.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/12.
//  Copyright © 2017年 gary. All rights reserved.
//

import HandyJSON

struct FamilyRecordModel: HandyJSON {
    
    var memberId:String?
    var phone:String?
    var nickName:String?
    var sex = 1
    var shareLocation:String?
    
    var memberPicUrl:String?
    
    var title:String?
    var remind:String?

}
