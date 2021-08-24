//
//  ProvinceCityModel.swift
//  YiYangClould
//
//  Created by Gary on 15/10/23.
//  Copyright © 2017年 Gary. All rights reserved.
//

import Foundation

class ProvinceCityModel:PickerBaseModel  {
    
    typealias Element = CityAreaModel
    
    init(dict : NSDictionary){
        super.init()
        
        var cityAreaArray : Array<CityAreaModel> = []
        (dict["cities"] as AnyObject).enumerateObjects({
            (element,idx,stop) in
            
            let cityAreaModel : CityAreaModel = CityAreaModel(dict: element as! NSDictionary)
            cityAreaArray.append(cityAreaModel)
            
        })
        
        self.subArr = cityAreaArray
        self.text = dict["state"] as! String
    }
}


class CityAreaModel:PickerBaseModel {

    typealias Element = String

    init(dict : NSDictionary){
        super.init()
        
        if let stateStr : String = dict["state"] as? String{
            self.text = stateStr
        }
        
        var areaArr : Array<PickerBaseModel> = []
        (dict["areas"] as AnyObject).enumerateObjects({
            (element,idx,stop) in
            
            let areaModel : PickerBaseModel = PickerBaseModel(element as! String)
            areaArr.append(areaModel)
        })
        
        self.subArr = areaArr
    }
    
}

