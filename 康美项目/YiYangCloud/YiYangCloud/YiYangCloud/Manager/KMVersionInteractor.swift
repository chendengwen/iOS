//
//  KMVersionInteractor.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import Alamofire

class KMVersionInteractor: BaseInteractor {
    
    convenience init(_ apiString:String = "http://itunes.apple.com/lookup?id=1044990892") {
        self.init()
        api = apiString
    }
    
    typealias VersionTurple = (update:Bool , version:String)
    
    static func checkVersion(success: @escaping (_ update:Bool , _ version:String) -> Void, failed fail: @escaping (String?) -> Void) {
        Alamofire.request("http://itunes.apple.com/lookup?id=1044990892", method: HTTPMethod.post, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseString { response in
//                debugPrint(response)
            
                switch response.result {
                case .success:
                    let json = try? JSONSerialization.jsonObject(with: (response.result.value?.data(using: .utf8)!)!, options: .allowFragments) as! [String: Any]
                    
                    if json?["resultCount"] as! Int >= 1 {
                        let resultDic = (json?["results"] as! Array<Any>).first as! [String: Any]
                        let version = resultDic["version"] as! String
                        
                        if version != Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String {
                            success(true,version)
                        }else {
                            success(false,version)
                        }
                        
                        return
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
}
