//
//  健康管理H5
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//
//  缓存操作工厂方法

/*
 设计说明
 1.队列管理: 工厂并行处理任务，车间串行处理任务
 2.缓存类型 document、sql、achievei、plist
 3.接收参数：Model、Type、FileName、Path
 4.功能：增删改查
 
 5.保存model时给model动态添加一个hashKey，用来区分model
 */

#warning("障碍")
//1.动态添加属性
//2.model转data
//3.

import Foundation

enum CacheType {
    case Document
    case SQL
    case Archieve
}

enum CacheOperationResult {
    case success
    case fail(_ message :String)
}

//protocol CacheOperation {
//    associatedtype T
//
//    func save(model :Any) -> CacheOperationResult
//    func delete(model :Any) -> CacheOperationResult
//    func update(key :String, value :Any) -> CacheOperationResult
//    
//}

class CacheFactory {
    
    private init(){
        
    }
    
    
}
