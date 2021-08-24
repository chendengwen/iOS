//
//  BaseModel.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/14.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON

var ivarDictionary:Dictionary<String, Any> = [:]

protocol BaseModelProtocol:NSObjectProtocol {
    static func instanceWithDic(dic:Dictionary<String, Any>) -> AnyObject?
    
    static func initWithDic(dic:Dictionary<String, Any>) -> AnyObject
    
    static func initWithDic(dic:Dictionary<String, Any>, mapping:Dictionary<String, Any>) -> Any
    
    static func modelArrayWithDicArray(arr:Array<Any>) -> Array<Any>
}

class BaseSModel: NSObject {
    
    override var description: String {
        
        
        get {
            
            var cls:AnyClass = self.classForCoder
            let clsName = class_getName(cls)
            let className:String = String(cString:clsName!)
            
            if ivarDictionary[className] == nil {
                
                var ivarList = Array<String>()
                var count:UInt32 = 0
                
                repeat {
                    let properList = class_copyPropertyList(cls, &count)
                    for index in 0 ... count-1 {
                        let item = properList?[Int(index)]
                        let proper_name = property_getName(item)
                        let properName = String(cString:proper_name!)
                        ivarList.append(properName)
                    }
                    
                    cls = class_getSuperclass(cls)
                } while cls != BaseSModel.classForCoder()
                
                ivarDictionary.updateValue(ivarList, forKey: className)
            }
            
            let ivarArray = ivarDictionary[className] as! Array<String>
            let ivarDic = NSDictionary()
            for ivar:String in ivarArray {
                let value:Any = self.value(forKey: ivar)!
                ivarDic.setValue(value, forKey: ivar)
            }
            
            let description = ivarDic.description
            return description
        }
    }
    
}



extension BaseSModel:BaseModelProtocol{

    static func instanceWithDic(dic: Dictionary<String, Any>) -> AnyObject? {
        return self.initWithDic(dic: dic)
    }
    
    static func initWithDic(dic: Dictionary<String, Any>) -> AnyObject{
//        if dic is Dictionary<String, Any> {}
        
        struct Once {
            static let setMethodString:String = "set%@:"
            static var dataType:UnsafePointer<Int8>? = nil
        }
        
        if Once.dataType == nil {
//            let stringCls = ""
//            Once.dataType = class_getName(stringCls.classForCoder)
        }
        

        return self
        
    }
    
    static func initWithDic(dic:Dictionary<String, Any>, mapping:Dictionary<String, Any>) -> Any{
        return Dictionary<String, Any>() as Any
    }
    
    static func modelArrayWithDicArray(arr:Array<Any>) -> Array<Any>{
        return Array<Any>() as Array
    }
    
}


// 服务端返回的统一定义的response格式
struct BaseResponse<T:HandyJSON>: HandyJSON {
    var code: Int? // 服务端返回码
    var success: Bool = true
    var message: String!
    
    // 具体的data的格式和业务相关，数组或字典
    var content: ArrayOrDictionary?
    
}

protocol ArrayOrDictionary {}
extension Array:ArrayOrDictionary {}
extension Dictionary:ArrayOrDictionary {}


// 遵循RawRepresentable协议的类型可以表示另一个类型，并且可以通过 rawValue这个属性得到它表示的值。
struct PreferenceName<Type>: RawRepresentable {
    typealias RawValue = String
    
    var rawValue: String
    
    init?(rawValue: PreferenceName.RawValue) {
        self.rawValue = rawValue
    }
}

extension UserDefaults {
    
    subscript(key: PreferenceName<Bool>) -> Bool {
        set { set(newValue, forKey: key.rawValue) }
        get { return bool(forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceName<Int>) -> Int {
        set { set(newValue, forKey: key.rawValue) }
        get { return integer(forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceName<Any>) -> Any {
        set { set(newValue, forKey: key.rawValue) }
        get { return value(forKey: key.rawValue) ?? "" }
    }
    
}

struct PreferenceNames {
    
    static let maxCacheSize = PreferenceName<Int>(rawValue: "MaxCacheSize")
    
    static let badgeType = PreferenceName<Int>(rawValue: "BadgeType")
    
    static let backgroundImageURL = PreferenceName<URL>(rawValue: "BackgroundImageURL")
    
}

// 测试 RawRepresentable 的强大功能
//UserDefaults.standard[PreferenceNames.maxCacheSize!] = 30
