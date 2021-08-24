//
//  KMFoundation.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/19.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON

// 操作符重载
func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
//            left.updateValue(v, forKey: k)
    }
}

protocol Idable {
    var id : String { get }
}


//Mark: String
extension String {

}

//Mark: Array
extension Array where Element: Any{
    
    mutating func addHandyArray(_ array:Array<Element>) {
        // 简单遍历
        for item in array {
//            print(item)
            self.append(item)
        }
        
        // 元祖遍历
        for (index,item) in array.enumerated() {
            print(item,"\(index)", separator: ", ")
        }
        
        // 反向遍历
        for (index,item) in array.enumerated().reversed() {
            print(item,"\(index)", separator: ", ")
        }
    }

//    func filterWithId<T>(id : String) -> [T] where T : Idable {
//        return self.filter { (item : T) -> Bool in
//            return item.id == id
//        }
//    }

    mutating func addHandyObject(_ item:Element) {
        self.append(item)
    }

}

//Mark: Dictionary
extension Dictionary {


}
