//
//  CacheDocument.swift
//  健康管理H5
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//

import Foundation

fileprivate let QueueName = "document.io.queue"
fileprivate let CachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0].appending("/DataCache/")

class CacheDocument {
    
    private let fileManager = FileManager.default
    // 默认的本地缓存根目录地址
    private var dataCachePath = CachePath
    //操作队列
    private let ioQueue:DispatchQueue = DispatchQueue(label: QueueName)
    
    var cachePath:String {
        set(newVal) {
            dataCachePath = newVal
        }
        get {
            return dataCachePath
        }
    }
    
    public static var shareCache = CacheDocument()
    
}

extension CacheDocument {
    
    func save(data: Data, path: String = CachePath, filename: String) -> CacheOperationResult {
        
        if !fileManager.fileExists(atPath: dataCachePath) {
            do{
                try fileManager.createDirectory(at: URL(fileURLWithPath: dataCachePath), withIntermediateDirectories: true, attributes: nil)
            }catch{
                return .fail("失败了")
            }
        }
        
//        do{
//            let data = model.da
//            
//            try data.write(to: URL(fileURLWithPath: dataPath), options: Data.WritingOptions.atomicWrite)
//        }catch{
//            NSLog("write error")
//        }
        
        return .fail("失败了")
    }
    
    func delete(path: String = CachePath, filename: String) -> CacheOperationResult {
        if !fileManager.fileExists(atPath: dataCachePath) {
            return .fail("文件不存在")
        } else {
            do{
                try fileManager.removeItem(atPath: dataCachePath)
            }catch{
                return .fail("失败了")
            }
        }
        return .success
    }
    
    func update(data: Data, path: String = CachePath, filename: String) -> CacheOperationResult {
        return .success
    }
}
