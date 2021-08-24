//
//  RLMModel.swift
//  BNOA
//
//  Created by Cary on 2019/11/12.
//  Copyright © 2019 BNIC. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    @objc dynamic var phoneNo = ""
    @objc dynamic var name = ""
    @objc dynamic var gender = 1
}
