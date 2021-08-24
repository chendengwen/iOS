//
//  KMNetWork.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

/*
 let urlRequest = URLRequest(url: URL(string: "https://httpbin.org/get")!)
 let urlString = urlRequest.url?.absoluteString
 */

class KMNetWork: KMNetWorkProtocol {
    
    static func fetchData(urlStrig: URLConvertible) -> DataRequest {
        // method defaults to `.get`
        return Alamofire.request(urlStrig).responseJSON(completionHandler: { (response) in  // response:DefaultDataResponse
            
        })
    }
    
    //Mark: request - Get
    @discardableResult static func fetchData(urlStrig: URLConvertible, success:@escaping (JSON?) -> Void, failed fail:@escaping (String?) -> Void) -> DataRequest {
        return Alamofire.request(urlStrig).validate().responseString(completionHandler: { (response) in
            switch response.result {
            case .success:
                success(response.result.value!)
            case .failure(let error):
                fail(error.localizedDescription)
            }
        })
    }
    
    @discardableResult static func fetchData(urlStrig: URLConvertible, parameters:Parameters, success:@escaping Success, failed fail:@escaping Failed) -> DataRequest {

        return fetchDataMethod(method: .get, urlStrig: urlStrig, parameters: parameters, success:success, failed :fail)
    }
    
    //Mark: request - Post
    @discardableResult static func fetchDataPost(urlStrig: URLConvertible, parameters:Parameters?, success:@escaping Success, failed fail:@escaping Failed) -> DataRequest {
        
        return fetchDataMethod(method: .post, urlStrig: urlStrig, parameters: parameters, success:success, failed:fail)
    }
    
    @discardableResult static func fetchDataMethod(method:HTTPMethod, urlStrig: URLConvertible, parameters:Parameters?, success:@escaping Success, failed fail:@escaping Failed) -> DataRequest {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return Alamofire.request(urlStrig, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseString { response in
                
                switch response.result {
                case .success:
                    let json = try? JSONSerialization.jsonObject(with: (response.result.value?.data(using: .utf8)!)!, options: .allowFragments) as! [String: Any]
                    
                    if json?["errorCode"] as! Int == 0 {
                        success(response.result.value)
                        return
                    } else {
                        fail(json?["msg"] as? String)
                    }
                    
                    ErrorHandler.errorHandle(response.result, afterHandle: { (errorMessage) in
                        fail(errorMessage)
                    })
                case .failure(_):
                    ErrorHandler.errorHandle(response.result, afterHandle: { (errorMessage) in
                        fail(errorMessage)
                    })
                }
        }
    }
    
    
    //Mark: download
    @discardableResult static func download(urlString:URLConvertible) -> DownloadRequest {
        
        let destination = DownloadRequest.suggestedDownloadDestination()
        return Alamofire.download(urlString, to: destination).validate().responseData { response in
            debugPrint(response)
            print(response.temporaryURL ?? "")
            print(response.destinationURL ?? "")
        }
    }
    
    @discardableResult static func downloadMethod(urlStrig: URLConvertible, parameters:Parameters, success:((Any?) -> Void)?, failed fail:@escaping Failed) -> DownloadRequest {
        
        let fileURL: URL? = nil
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL!, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        return Alamofire.download(urlStrig, method: .get, parameters: parameters, encoding: JSONEncoding.default, to: destination)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, temporaryURL, destinationURL in
//                success!("下载成功")
                return .success
            }
            .responseString { response in
                debugPrint(response)
                print(response.temporaryURL ?? "")
                print(response.destinationURL ?? "")
                ErrorHandler.errorHandle(response.result, afterHandle: { (errorMessage) in
                    fail(errorMessage)
                })
        }
    }
    
    
    //Mark: upload
    static func upload(multipartFormData: @escaping (MultipartFormData) -> Void, urlString:URLConvertible, success:@escaping Success, failed fail:@escaping Failed) {
        
        Alamofire.upload(multipartFormData:multipartFormData , to: urlString) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    
                    switch response.result {
                    case .success:
                        if let myJson = response.result.value {
                            success(myJson)
                        }else {
                            print("上传失败")
                        }
                        
                        ErrorHandler.errorHandle(response.result, afterHandle: { (errorMessage) in
                            fail(errorMessage)
                        })
                    case .failure(_):
                        ErrorHandler.errorHandle(response.result, afterHandle: { (errorMessage) in
                            fail(errorMessage)
                        })
                    }
                })
            case .failure(let error):
                fail(error.localizedDescription)
            }
        }
    }
    
    static func upload(fileURL:URL, urlRequest:URLRequestConvertible) {
        Alamofire.upload(fileURL, with: urlRequest).validate().responseData { response in
            debugPrint(response)
        }
    }
    
    static func upload(fileURL:URL, urlString:URLConvertible, parameters:Parameters, success:@escaping Success, failed fail:@escaping Failed) {
        
        Alamofire.upload(fileURL, to: urlString, method: .put)
            .uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .downloadProgress { progress in // called on main queue by default
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
//                success(data)
                return .success
            }
            .responseString { response in
                debugPrint(response)
                
                switch response.result {
                case .success:
                    success(response.result.value!)
                case .failure(_):
                    ErrorHandler.errorHandle(response.result, afterHandle: { (errorMessage) in
                        fail(errorMessage)
                    })
                }
                
                
        }
    }
    
}
