//
//  FamilyInteractor.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class FamilyInteractor:BaseInteractor {
    
    //Mark: 区分家庭圈列表和家庭圈搜索 1-列表  0-搜索
    var type = 1
    
    convenience init(_ apiString: String, _ apiType:Int) {
        self.init()
        
        type = apiType
        api = apiString + "/" + "\(apiType)"
    }
    
}
