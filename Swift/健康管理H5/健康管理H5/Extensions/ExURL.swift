//
//  ExURL.swift
//  健康管理H5
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 Gary. All rights reserved.
//

import UIKit

extension URL {
    
    //获取url中的参数
    public var paramsFromQueryString : [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else { return nil }
        
        return queryItems.reduce(into: [String: String](), { (result, item) in
            result[item.name] = item.value
        })
    }
}
