//
//  ArrayExtension.swift
//  BNOA
//
//  Created by Cary on 2019/11/27.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit

public func ==<T:Equatable>(lhs:[T]?,rhs:[T]?) -> Bool {
    switch (lhs, rhs) {
    case let (lhs?, rhs?):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}

extension Array {
    
    // 随机获取一个元素
    public func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
    // 是否包含某类元素
    public func containsType<T>(of element:T) -> Bool {
        let elmType = type(of: element)
        return self.contains { type(of: $0) == elmType }
    }
    
    // 获取指定元素
    public func object(at index:Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    // 起始位插入一个新元素
    mutating public func insertAtFirst(_ newElm: Element) {
        insert(newElm, at: 0)
    }
    
    // 获取正序索引的倒叙索引
    public func reverseIndex(_ index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }
        return Swift.max(count - 1 - index, 0)
    }
    
    // 获取以给定个数为最大个数的新数组
    public func takeMax(_ n: Int) -> Array {
        return Array(self[0..<Swift.max(0, Swift.min(n, count))])
    }
    
    // 检查是否所有元素都满足某个条件
    public func testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        return !contains { !body($0) }
    }
}

extension Array where Element: Equatable {
    
    // 检测是否包含m指定数组
    public func contains(_ array:[Element]) -> Bool {
        return array.testAll { self.firstIndex(of: $0) ?? -1 >= 0 }
    }
    
    // 是否包含一列元素
    public func contains(_ elements: Element...) -> Bool {
        return elements.testAll { self.firstIndex(of: $0) ?? -1 >= 0 }
    }
    
    // 组合多个数组
    public func union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }
    
    // 删除多个指定的元素
    mutating public func removeAll(_ elements: [Element]) {
        self = filter { !elements.contains($0) }
    }
}
