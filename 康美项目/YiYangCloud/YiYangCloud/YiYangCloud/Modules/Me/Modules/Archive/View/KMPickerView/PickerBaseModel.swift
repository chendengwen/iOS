//
//  PickerBaseModel.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/12.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

//class PickerBaseModel<T:PickerModelProtocol> {
class PickerBaseModel:PickerModelProtocol {
    // 子类根据需要指定，但必须是PickerBaseModel的子类
    typealias Element = PickerBaseModel

    func getSubArr() -> Array<Element> {
        return subArr 
    }
    
    func getText() -> String {
        return text
    }

    var subArr : Array<PickerBaseModel.Element> = []
    
    var text : String = ""
    
    init(_ Text:String = "") {
        text = Text
    }
    
}

protocol PickerModelProtocol {
    associatedtype Element
    
    func getSubArr() -> Array<Element>
    func getText() -> String
}
