//
//  LXFModel.swift
//  RxSwiftDemo
//
//  Created by 林洵锋 on 2017/9/7.
//  Copyright © 2017年 LXF. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct LXFModel: Mappable {
    var views               = 0
    var title               = ""
    var publishedAt         = ""
    var url                 = ""
    var likeCounts          = 0
    var type                = ""
    var images:[String]?    = nil
    var stars               = 0
    var desc                = ""
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        views       <- map["views"]
        title       <- map["title"]
        desc        <- map["desc"]
        publishedAt <- map["publishedAt"]
        likeCounts  <- map["likeCounts"]
        type        <- map["type"]
        url         <- map["url"]
        stars       <- map["stars"]
        images      <- map["images"]
    }
}


/* ============================= SectionModel =============================== */

struct LXFSection: SectionModelType {
    
    typealias Item = LXFModel
    var items: [Item]
    
    init(original: LXFSection, items: [LXFSection.Item]) {
        self = original
        self.items = items
    }
}

