//
//  LocationRecord.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/23.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON

struct LocationRecord: HandyJSON {
    
    var memberId:String?
    var address:String?
    var lat:Float?
    var lng:Float?
    var type:String?
    
    var hpe:Int?
    var imei:String?
    var imsi:String?
    var isvalid:String?
    var name:String?
    var locMethod:String?
    
    var createDate:String?
    var updateDate:String?
    
    var eventDate:String?
    var eventDetailKey:String?
    var eventKey:String?
    var eventno:Int?
    
    var lbsDate:String?
    var lbsDetailKey:String?
    var lbsKey:String?
    var lbsno:Int?

    func getData() -> String {
        if lbsDate != nil , (lbsDate?.characters.count)! > 0 { return lbsDate! }
        return eventDate!
    }
    
    func getTypeTitle() -> String {
        if lbsDate != nil , (lbsDate?.characters.count)! > 0 { return "活动区域" }
        return "救援记录"
    }
    
    func getLocationTypeImage() -> String {
        guard locMethod != nil,(locMethod?.characters.count)! > 0 else { return ""}
        
        if locMethod == "G" {return "GPS"}
        else if locMethod == "C" {return "4G"}
        else {return "Wifi"}
    }
}
