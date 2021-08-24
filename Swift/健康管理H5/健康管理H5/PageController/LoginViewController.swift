//  ViewController.swift
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019 Gary. All rights reserved.
//
//  登录页面，获取token

import UIKit
import WebKit

class LoginViewController: BaseWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webTitle = "登录"
        hideBackButton = true
        
        
        initWebView()
        self.webView.uiDelegate = self
        loadWebView(url: getLoginHtml())
    }
    
    func getLoginHtml() -> URL {
        
        // 加载登录html
        let filePath = BoundFilePath("/Html/login_H5&360App.html")
        
        // 加载本地的整个html项目
        //let filePath = BoundFilePath("/Html/ctms/index.html")
        return URL.init(fileURLWithPath: filePath)
    }

}

extension LoginViewController:WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let dict = handleAlertMessage(jsonStr: message)
        if dict != nil {
            let dataDict = dict! as NSDictionary
            let keyArr = dataDict.allKeys as! Array<String>
            
            print(dataDict)
            let containsToken = keyArr.contains { $0 == "token_H5" }

            if containsToken {
                let token_H5 = dataDict.object(forKey: "token_H5") as! String
                let token_360App = dataDict.object(forKey: "token_360App") as! String
                
//                let urlString = "http://192.168.1.105:8080/?token_H5=\(token_H5!)&token_360App=\(token_360App!)"
                let urlString = "http://10.2.32.67:8080/?token_H5=\(token_H5)&token_360App=\(token_360App)"
                
//                let urlString = BoundFilePath("/Html/ctms/index.html")
                
                let webCtl = HomeViewController()
                webCtl.hideNavBar = true
                webCtl.url = urlString
                self.navigationController?.pushViewController(webCtl, animated: true)
            }
            
            // 保存用户信息
            UserInfoModel.shareCache.update(with: dataDict as! Dictionary<String, Any>)
            
        }
        
        completionHandler()
    }
}

