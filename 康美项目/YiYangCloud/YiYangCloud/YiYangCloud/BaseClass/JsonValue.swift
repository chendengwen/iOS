//
//  JsonValue.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/14.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON

typealias JSON = Any
public protocol JSONValue {}

//使用 Struct 来代替 Class 作为数据模型有很多好处。值类型（value type）是非常有优势的
// 1 没有引用计数,所以不会因为循环引用导致内存泄漏
// 2 值类型通常来说是以栈的形式分配的，而不是用堆。因此他们比 Class 要快很多，真的*很多*！
// 3 值类型是自动线程安全的。无论你从哪个线程去访问你的 Struct ，都非常简单。

//缺点
// 1 不能继承
// 2 oc不能调用
// 3 不能序列化  Swift4.0可以序列化了
struct BaseStruct {}

//在Struct中的函数，默认（不添加mutating关键字）的函数对Struct中属性只有只读权限。
//如果添加上mutating, 那么该函数就对属性持有读写的权限。
extension BaseStruct {
    static func from(json:JSON) -> BaseStruct? {
        return nil
    }
}

func value<T: JSONValue>(json:JSONValue,key:String) ->T? {
    return (json as AnyObject).value(forKey:key) as! T?
}



extension Int:JSONValue {

}

extension Double:JSONValue {
    
}

extension Bool:JSONValue {
    
}

extension String:JSONValue {
    
}

extension Dictionary:JSONValue {
    
}

extension Array:JSONValue {
    
}

//
extension JSONDeserializer {
    public static func deserializeContentFrom<T: HandyJSON>(json: String?) -> T? {
        return JSONDeserializer<T>.deserializeFrom(json: json,designatedPath: "content")
    }
}

public extension Array where Element: HandyJSON {
    public static func deserializeContent(from json: String?) -> [Element?]? {
        let arr = JSONDeserializer<Element>.deserializeModelArrayFrom(json: json, designatedPath: "content")

        return arr
    }
}
