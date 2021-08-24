//
//  KMNetWorkProtocol.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import Alamofire

protocol KMNetWorkProtocol {
    
    typealias Success = (JSON?) -> Void
    typealias Failed = (String?) -> Void
    
    
    static func fetchData(urlStrig:URLConvertible) -> DataRequest
    
    //Mark: request
    static func fetchData(urlStrig: URLConvertible, parameters:Parameters, success:@escaping Success, failed fail:@escaping Failed) -> DataRequest
    
    static func fetchDataPost(urlStrig: URLConvertible, parameters:Parameters?, success:@escaping Success, failed fail:@escaping Failed) -> DataRequest
        

    //Mark: download
    static func download(urlString:URLConvertible) -> DownloadRequest
    
    static func downloadMethod(urlStrig: URLConvertible, parameters:Parameters, success:((Any?) -> Void)?, failed fail:@escaping Failed) -> DownloadRequest
    
    
    //Mark: upload
    static func upload(multipartFormData:@escaping (MultipartFormData) -> Void, urlString:URLConvertible, success:@escaping Success, failed fail:@escaping Failed) // -> UploadRequest
    
    static func upload(fileURL:URL, urlRequest:URLRequestConvertible) // -> UploadRequest
    
    static func upload(fileURL:URL, urlString:URLConvertible, parameters:Parameters, success:@escaping Success, failed fail:@escaping Failed) // -> UploadRequest
    
}

// 限定T是class1这个类的对象，同时遵循testProtocol1和testProtocol2
//func findMinTemplateFunc<T : testCalss where T :protocol<testProtocol1,testProtocol2>>(datas: [T]) -> T?
