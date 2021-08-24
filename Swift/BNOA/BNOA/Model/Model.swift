//
//  BNModel.swift
//  BNOA
//
//  Created by Cary on 2019/11/8.
//  Copyright © 2019 BNIC. All rights reserved.
//

import HandyJSON

struct UserModel: HandyJSON {
    var uid: Int = 0
    var age: Int = 0
    var gender: Int = 1
    var name: String?
}

struct NewsModel:HandyJSON {
    var newsId: Int = 0
    var title: String?
    var author: String?
    var desp:String?
    var commentNo = 0
    var imageUrl: String?
}
