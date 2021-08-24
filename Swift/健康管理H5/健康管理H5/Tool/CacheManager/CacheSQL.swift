//
//  CacheSQL.swift
//  健康管理H5
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//

import UIKit

class CacheSQL {

    
}

extension CacheSQL {
    
    func save(model: Any) -> CacheOperationResult {
        return .fail("失败了")
    }
    
    func delete(model: Any) -> CacheOperationResult {
        return .success
    }
    
    func update(key: String, value: Any) -> CacheOperationResult {
        return .success
    }
}

