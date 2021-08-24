//
//  KMPickerModelFactory.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/11.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

protocol ComponentArrable {
    
}

enum KMPicker_Type:Int {
    
    case province = 0       // 省份城市
    case city               // 省份城市
    case area               // 省份城市区域
    
    case month = 5          // 时间-年月
    case day                // 时间-年月日
    case hour               // 时间-小时
    case minute             // 时间-小时分钟
    case second             // 时间-小时分钟秒
    
    func numberOfComponents() -> Int {
        switch self {
        case KMPicker_Type.province,KMPicker_Type.hour: return 1
        case KMPicker_Type.city,KMPicker_Type.month,KMPicker_Type.minute: return 2
        case KMPicker_Type.area,KMPicker_Type.day,KMPicker_Type.second: return 3
        }
    }
}

protocol KMPickerSourceProtocol {
    static func getDataArray(_ type:KMPicker_Type) -> [Any]
}

class KMPickerModelFactory: NSObject,KMPickerSourceProtocol {
    
    // 数据源 二维数组，元素个数为1/2/3
    var dataArray:[Any]?
    
    static func getDataArray(_ type:KMPicker_Type) -> [Any] {
        if type.rawValue < 5 {
            return Area.getDataArray(type)
        } else if type.rawValue >= 5 {
            return Time.getDataArray(type)
        }
        
        return []
    }
}


class Area:KMPickerSourceProtocol {
    static func getDataArray(_ type:KMPicker_Type) -> [Any] {
        var modelArray:[Any] = []
        
        let path : String = Bundle.main.path(forResource: "area", ofType: "plist")!
        let resourceArray = NSArray.init(contentsOfFile: path)
        
        resourceArray?.enumerateObjects({
            (item,idx,stop) -> Void in
            
            let model : ProvinceCityModel = ProvinceCityModel(dict: item as! NSDictionary)
            modelArray.append(model)
        })
        
        return modelArray
    }
}

typealias ComponentTuple = (index:Int,text:String)      // 每个隔段数据
typealias ComponentArray = Array<ComponentTuple>        // 每个隔段数据列表
// 选择年月日等时间时计算显示内容
class Time:KMPickerSourceProtocol {
    static func getDataArray(_ type:KMPicker_Type) -> [Any] {
        
        var array:Array<Any> = []
        
        switch type {
        case .month, .day:
            for year in 1950 ... 2017 {
                array.append(YearModel(year))
            }
            break
        case .hour:
            
            break
        case .minute:
            
            break
        case .second:
            
            break
        default:
            
            break
        }
        
        return array
    }
}


//extension Array where T: ComponentValue {
//
//    
//}



