//
//  ExString.swift
//  健康管理H5
//
//  Created by Cary on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//
import Foundation

extension String {
    
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    //String 转 Dictionary
    public func toDictionary() -> [String:Any]? {
        let data = self.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
    
    /*
     swift的UTF8对于英文符号编码结果是Unicode的编码数据    a -> \u0097
     objectC的UTF8对于英文符号编码结果是Native的编码数据   a -> \u0061
     "abc123" 编码
     swift-utf8      979899495051
     swift-ascii     979899495051
     swift-unicode   fffe9700 98009900 49005000 5100
     
     objectC-utf8    616263313233
     objectC-ascii   616263313233
     objectC-unicode fffe6100 62006300 31003200 3300
     
     Unicode         979899495051
     
     使用`utf8encodedString`来保证UTF8编码结果与OC一致
     */
    func utf8encoded() ->Data? {
        //截取每个字符，转码后减去36/18，再转回字符
        var resultData = Data.init(capacity: self.count)
        for oldCharNum in self.utf8 {
            let desValue:UInt8 = oldCharNum >= 65 ? 36 : 18
            let newCharNum:UInt8 = oldCharNum - desValue
            //            print("old == \(oldCharNum) new == \(newCharNum)")
            
            resultData.append(newCharNum)
        }
        
        return resultData
    }
    
    //使用正则表达式替换
    public func pregReplace(pattern: String, with: String,
                            options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    //判断是否是包含IP地址
    public func containsIP() -> Bool {
        let regex = try! NSRegularExpression(pattern: "((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})(\\.((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})){3}", options: [])
        let array = regex.matches(in: self, options: .reportCompletion, range: NSRange.init(location: 0, length: self.count))
        return array.count > 0
    }
    
}

