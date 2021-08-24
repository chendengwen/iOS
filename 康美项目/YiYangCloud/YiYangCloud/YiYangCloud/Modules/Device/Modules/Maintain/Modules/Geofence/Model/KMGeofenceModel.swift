//
//  KMGeofenceModel.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/18.
//  Copyright © 2017年 gary. All rights reserved.
//

/*
 @interface KMGeofenceModel : NSObject
 
 @property (nonatomic, copy) NSString *imei;
 
 @property (nonatomic, copy) NSString *fenceName;
 
 @property (nonatomic, assign) double longitude;
 
 @property (nonatomic, assign) double latitude;
 
 @property (nonatomic, copy) NSString *starttime;
 
 @property (nonatomic, copy) NSString *endtime;
 
 @property (nonatomic, assign) int enable;
 
 @property (nonatomic, copy) NSString *address;
 
 @property (nonatomic, assign) int radius;
 
 @property (nonatomic, assign) long long updatetime;
 
 @property (nonatomic, assign) long long createtime;
 
 @property (nonatomic, assign) int interval;
 */

import UIKit

class KMGeofenceModel: NSObject {
    var imei:String?
    var fenceName:String?
    var longitude:Double?
    var latitude:Double?
    var starttime:String?
    var endtime:String?
    var enable:Int?
    var address:String?
    var radius:Double?
    var updatetime:Int?
    var createtime:Int?
    var interval:Int?
}
