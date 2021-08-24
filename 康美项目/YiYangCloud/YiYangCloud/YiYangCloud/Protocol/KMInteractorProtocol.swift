//
//  KMInteractorProtocol.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/10.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit


@objc protocol KMInteractorProtocol {
    
    typealias Success = (JSON?) -> Void
    typealias Failed = (String?) -> Void
    
    @objc optional var api:String { set get }
    @objc optional var params:Dictionary<String, Any> { set get }
    
    @objc optional func `init`(_ apiString:String, _ paramsDic:Dictionary<String,Any>)
    
    //Mark: (对象方法)标准化网络请求方法名
    @objc optional func loadData(success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void)
    @objc optional func loadDataPost(success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void)
    
    @objc optional func sendDataOperation(success:(Data?) -> Void, failed fail:(String?) -> Void) -> Bool
    
    @objc optional func upload(_ data:Data, success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void)
    
    //Mark: (静态方法)标准化网络请求方法名  Tip: 调用此方法无法获得 request对象
    @objc static optional func loadData(urlStrig: String, parameters:Parameters, success:@escaping (JSON?) -> Void, failed fail:@escaping (String?) -> Void)
    
    @objc static optional func sendDataOperation(urlString: String, parameters:Parameters, success:(Data?) -> Void, failed fail:(String?) -> Void) -> Bool
    
    
    //Mark: 标准化事件响应名
    @objc optional func interactorSubmit()
    
    @objc optional func interactorCancel()
}


public protocol InteractorType {
    associatedtype InteractorType
    
     var type: InteractorType  { get }
}

public extension InteractorType {
    public var type:String {
        get {
            return ""
        }
    }
}
