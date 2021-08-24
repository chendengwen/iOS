//
//  BaseInteractor.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/19.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import Alamofire

public class BaseInteractor: KMInteractorProtocol {
    
    var api: String = ""
    var params: Dictionary<String, Any> = [:]
    
    // 暂存request，用来做取消／暂退操作
    var request:DataRequest? = nil
    
    var blockSuccess:Success = {_ in }
    var blockFailed:Failed = {_ in }
    
    convenience init() {
        self.init("")
    }
    
    init(_ apiString: String, _ paramsDic: Dictionary<String, Any> = [:]) {
        
        api = apiString
        params = paramsDic
    }
    
    func loadData(success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void) {
        
        blockSuccess = success
        blockFailed = fail
        
        request = KMNetWork.fetchData(urlStrig: api, success: success, failed: fail)
    }
    
    func loadDataPost(success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void) {
        
        blockSuccess = success
        blockFailed = fail
        
        request = KMNetWork.fetchDataPost(urlStrig: api, parameters: params, success: success, failed: fail)
    }
    
    func upload(_ data:Data, success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void) {
        blockSuccess = success
        blockFailed = fail
        
//        KMNetWork.upload(data: data, urlString: api, success: blockSuccess, failed: blockFailed)
    }
    
    // 重写的 -- 可以自定义参数
    func upload(_ multipartFormData: @escaping (MultipartFormData) -> Void, success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void) {
        blockSuccess = success
        blockFailed = fail
        
        KMNetWork.upload(multipartFormData: multipartFormData, urlString: api, success: blockSuccess, failed: blockFailed)
    }
    
    @objc static func loadData(urlStrig: String, parameters:Parameters, success: @escaping (JSON?) -> Void, failed fail: @escaping (String?) -> Void) {
        KMNetWork.fetchData(urlStrig: urlStrig, parameters: parameters, success: success, failed: success)
    }
    
    
//Mark: 基础类方法
    
    // 重新发一遍请求(取消之前的)
    func reloadData(_ apiString: String = "" ) {
        if request != nil {
            request?.cancel()
        }
        
        if apiString.characters.count > 0 {
            api = apiString
        }
        
        loadData(success: blockSuccess, failed: blockFailed)
    }
    
    private func requestFunctions() {
        // 取消
        request?.cancel()
        // 暂停
        request?.suspend()
        // 重新开始
        request?.resume()
    }
    
}
