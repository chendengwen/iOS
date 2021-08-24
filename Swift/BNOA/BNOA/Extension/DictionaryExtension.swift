//
//  DictionaryExtension.swift
//  BNOA
//
//  Created by Cary on 2019/11/8.
//  Copyright © 2019 BNIC. All rights reserved.
//

import Foundation

extension Dictionary {
    
    // 随机获取一个值
    public func random() -> Value? {
        return Array(values).random()
    }
    
    // 组合多个字典
    public func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) in
            dictionary.forEach({ (arg) in
                let (key, value) = arg
                result[key] = value
            })
        }
        return result
    }
    
    // 是否包含某个key
    public func hasKey(_ key:Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    // 按指定规则转成数组
    public func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        return self.map(map)
    }
    
    // 按指定规则过滤
    public func filter(_ test: (Key, Value) -> Bool) -> Dictionary {
        var result = Dictionary()
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        return result
    }
    
    // 检查是否所有键值对都满足某个条件
    public func testAll(_ test: (Key, Value) -> (Bool)) -> Bool {
        return !contains { !test($0, $1) }
    }
    
    // 转JSON
    public func formatJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
   
    // 自定义操作符
    static public func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
    }
    
}
