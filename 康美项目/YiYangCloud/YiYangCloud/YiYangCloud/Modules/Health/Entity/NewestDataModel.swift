//
//  NewestDataModel.swift
//  YiYangCloud
//
//  Created by zhong on 2017/5/3.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class NewestDataContent: NSObject {
    var bo:String?
    var bp:String?
    var bs:String?
    var hr:String?
    var step:String?
    var temperature:String?
}

class NewestDataModel: NSObject {
    var content:NewestDataContent?
    var errorCode:Int?
    var msg:String?
}
