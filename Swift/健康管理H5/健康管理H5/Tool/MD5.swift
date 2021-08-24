//
//  MD5.swift
//  健康管理H5
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//

import CommonCrypto

extension String {
    
    func MD5() -> String {
        let cStr = self.cString(using: String.Encoding.utf8)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        
        var md5String = String.init()
        for i in 0 ..< 16{
            let formatChar = String(format: "%02x", buffer[i])
            md5String.append(formatChar)
        }
        free(buffer)
        return md5String as String
    }
    
}
