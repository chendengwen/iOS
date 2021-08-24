//
//  KMTableView.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/19.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON
import DGElasticPullToRefresh

private var kDataArrayKey: String = "dataArrayKey"
private var kAPIKey: String = "apiKey"
private var kPageIndexKey: String = "pageIndexKey"
private var kISRefreshing: String = "isRefreshingKey"
private var kReuseCellID: String = "reuseCellIDKey"
public extension UITableView {
    
    enum LoadingState: Int {
        case normal = 0
        case refreshing = 1
        case loadingMore = 2
    }
    
    var dataArray: Array<HandyJSON>? {
        get { return (objc_getAssociatedObject(self, &kDataArrayKey) as? Array<HandyJSON>) }
        set(newValue) {
            objc_setAssociatedObject(self, &kDataArrayKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var api: String? {
        get { return (objc_getAssociatedObject(self, &kAPIKey) as? String) }
        set(newValue) {
            objc_setAssociatedObject(self, &kAPIKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var cellID: String {
        get { return (objc_getAssociatedObject(self, &kReuseCellID) as! String) }
        set(newValue) { objc_setAssociatedObject(self, &kReuseCellID, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    var pageIndex: Int {
        get {
            let index:NSNumber? = objc_getAssociatedObject(self, &kPageIndexKey) as? NSNumber
            return index != nil ? index!.intValue : 1
        }
        set(newValue) { objc_setAssociatedObject(self, &kPageIndexKey, NSNumber.init(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    var loadingState: LoadingState? {
        get {
            let state:NSNumber? = objc_getAssociatedObject(self, &kISRefreshing) as? NSNumber
            return state != nil ? LoadingState.init(rawValue: state!.intValue)! : .normal
        }
        set(newValue) { objc_setAssociatedObject(self, &kISRefreshing, NSNumber.init(value: (newValue?.rawValue)!), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    
    
    func addOnePage() {
        pageIndex = pageIndex + 1
        self.loadingState = .loadingMore
    }
    
    //Mark: 根据状态处理新数据
    func loadDataArray(_ array:Array<HandyJSON>) {
        if self.loadingState == .refreshing || self.loadingState == .normal {
            self.dataArray?.removeAll()
            self.dataArray = array
        } else if self.loadingState == .loadingMore {
            self.dataArray = self.dataArray! + array
        }
    }
    
    //Mark: 新数据json处理
    func loadDataFinish<T>(_ jsonString:String?, viewBlock:@escaping () -> Void, modelType:T) where T : HandyJSON {
        if let modelArray = Array<T>.deserializeContent(from: jsonString) as? Array<T> {
            self.loadDataArray(modelArray)
        }
        DispatchQueue.main.async(execute: {
            viewBlock()
        })
    }
    
    
    //Mark: 结束加载动画  当前仅支持处理DGElasticPullToRefresh的控价
    func loadViewFinish(_ isSuccess:Bool) {
        if self.es_header != nil {
            if self.loadingState == .refreshing {
                self.es_stopPullToRefresh()
            } else if self.loadingState == .loadingMore {
                self.es_stopLoadingMore()
                if isSuccess == false {
                    pageIndex = pageIndex - 1
                }
            }
        }
        
        loadingState = .normal
    }
}
