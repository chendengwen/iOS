//
//  AES.swift
//  H5演示Demo
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 Gary. All rights reserved.
//

import UIKit
import CommonCrypto

enum CryptError: Error {
    case noIV
    case cryptFailed
    case notConvertTypeToData
}

let AES_KEY = "VoSkEFQayXJT47VW"

extension Data {
    
    /*
     opterantion: CCOperation {
        kCCEncrypt = 0    --> 加密
        kCCDecrypt        --> 解密
     }
     
     options: CCOptions {
        kCCOptionPKCS7Padding   = 0x0001      --> 需要iv
        kCCOptionECBMode        = 0x0002      --> 不需要iv
     }
     
     key       公钥
     iv        偏移量
     */
    
    // AES128
    func dataCryptAES128(_ operation: CCOperation, _ key: String, _ options: CCOptions?, _ iv: String?)  throws -> Data {
        return try self.dataCrypt(operation,
                                  key,
                                  options ?? CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
                                  iv,
                                  CCAlgorithm(kCCAlgorithmAES))
    }
    
    // 基本方法
    func dataCrypt(_ operation: CCOperation, _ key: String, _ options: CCOptions, _ iv: String?, _ algorithm: UInt32) throws -> Data {

        if iv == nil && (options & CCOptions(kCCOptionECBMode)) == 0 {
            print("Error in crypto operation: dismiss iv!")
            throw(CryptError.noIV)
        }

        //data(input)
        let dataBytes = self.bytes()
        let dataLength = size_t(self.count)
        //data(output)
        var buffer = Data(count: dataLength + Int(kCCBlockSizeAES128))
        let bufferBytes = buffer.mutableBytes()
        let bufferLength = size_t(buffer.count)
        //iv
//        let ivBuffer: UnsafePointer<UInt8>? = iv == nil ? nil : iv!.bytes()
        let ivBuffer = iv ?? ""
        
        var bytesDecrypted: size_t = 0

        let cryptState = CCCrypt(operation,
                                 algorithm,
                                 options,
                                 key, size_t(kCCKeySizeAES128),
                                 ivBuffer,
                                 dataBytes, dataLength,
                                 bufferBytes, bufferLength,
                                 &bytesDecrypted)
        
        guard Int32(cryptState) == Int32(kCCSuccess) else {
            print("Error in crypto operation: \(cryptState)")
            throw(CryptError.cryptFailed)
        }
        
        buffer.count = bytesDecrypted
        return buffer
    }
    
    //===>>>>>>>Help Funcations<<<<<<<===//
    func bytes() -> UnsafePointer<UInt8> {
        return self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            print(bytes[0])
            print(bytes[1])
            return bytes
        }
    }
    
    mutating func mutableBytes() -> UnsafeMutablePointer<UInt8> {
        return self.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
    }
    
}
