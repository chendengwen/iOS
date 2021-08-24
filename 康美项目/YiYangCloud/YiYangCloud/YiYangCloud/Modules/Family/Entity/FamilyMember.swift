//
//  FamilyMember.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/13.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

import HandyJSON

class FamilyMember: HandyJSON {
    
    var memberId:String?
    var phone:String?
    var nickName:String?
    var sex = 1
    var shareLocation:String?
    
    var memberPicUrl:String?
    var relationShip:String?
    
    var title:String?
    var remind:String?
    
    var numInFamily:Int8?

    required init() {
        title = "没啥病"
        remind = "好几天没查了"
    }
    
}


