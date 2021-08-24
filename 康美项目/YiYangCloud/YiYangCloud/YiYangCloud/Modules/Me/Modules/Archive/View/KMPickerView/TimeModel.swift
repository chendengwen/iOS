//
//  TimeModel.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/11.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class YearModel:PickerBaseModel  {
    
    typealias Element = MonthModel
    
    init(_ year:Int) {
        super.init()
        
        text = "\(year)"
        
        subArr = {
            var arr:[MonthModel] = []
            for i in 1 ... 12 {
                arr.append(MonthModel(i))
            }
            return arr
        }()
    }

}

class MonthModel:PickerBaseModel  {
    
    typealias Element = String
    
    init(_ month:Int) {
        super.init()
        
        text = String(format: "%02i", month)
        
        switch month {
        
        case 1,3,5,7,8,10,12:
            subArr = {
                var arr:[PickerBaseModel] = []
                for i in 1 ... 31 {
                    arr.append(PickerBaseModel(String(format: "%02i", i)))
                }
                return arr
            }()
            break
        case 4,6,9,11:
            subArr = {
                var arr:[PickerBaseModel] = []
                for i in 1 ... 30 {
                    arr.append(PickerBaseModel(String(format: "%02i", i)))
                }
                return arr
            }()
            break
        case 2:
            subArr = {
                var arr:[PickerBaseModel] = []
                for i in 1 ... 29 {
                    arr.append(PickerBaseModel(String(format: "%02i", i)))
                }
                return arr
            }()
            break
            
        default: break
        }
    }
}
