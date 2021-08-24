//  MallViewController.swift
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 Gary. All rights reserved.
//
//  商城页面

import UIKit
import WebKit

class MallViewController: BaseWebViewController {
    
    // 商城链接
    private let URL_TEST = "http://testkmjkzx.kmwlyy.com/web/shop/o2o/index/userAuthenticationGet"
    private let URL_RELEASE = "http://kmjkzx.kmwlyy.com/web/shop/o2o/index/userAuthenticationGet"
    
    // 支付回调域名
    private let HOST_PAY    = "kmjkgl.com://"
    private let HOST_PAY_A1 = "a1.kmwlyy.com://"

    var url: String?
    var goodsID: String?
    private var paySuccessedURL: String?
    
    lazy var closeButton = { () -> UIButton in
        let closeButton = UIButton.init(type: .custom)
        closeButton.frame = CGRect.init(x: 42, y: NavTopSpace, width: 16, height: 16)
        closeButton.setImage(UIImage.init(named: "close_icon_white"), for: .normal)
        return closeButton
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWebView()
        navBar.addSubview(closeButton)
        webView.navigationDelegate = self
        
        self.startLoading()
        url = url ?? getMallUrl()
        loadWebView(url: URL.init(string: url!)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(paySuccessed), name: NSNotification.Name.Notification_PaySuccess, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navBar.backButton.removeTarget(navBar, action: #selector(navBar.backButtonClicked), for: .allEvents)
        print(navBar.backButton.allTargets)
        navBar.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
    }
    
}

// 事件响应
extension MallViewController {
    
    @objc func backButtonClicked() {
        if goodsID != nil {
            self.navigationController?.popViewController(animated: true)
        } else if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func closeButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func paySuccessed() {
        guard paySuccessedURL != nil else {
            return
        }
        
        loadWebView(url: URL.init(string: paySuccessedURL!)!)
    }
}

// URL处理
extension MallViewController {
    
    func getMallUrl() -> String {
        
        var params :Dictionary<String, Any> = [:]
        params["orgId"] = "ZSZG"
        params["groupId"] = "a28dc233c40944b9b689f110dfb11a26"
//        let uid = UserInfoModel.shareCache.uid_360App
        params["telPhone"] = UserInfoModel.shareCache.uid_360App // person.Data.ID
        params["openId"] = UserInfoModel.shareCache.phone
        
        if (goodsID != nil && goodsID!.count > 0) {
            params["action"] = "DETAIL"
            params["actionData"] = goodsID
        }
        
        let timeVal = NSDate().timeIntervalSince1970*1000
        params["time"] = "\(timeVal)"
        
        // 序列化、加密、百分比符号替换
        let paramsData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let aesData = try! paramsData.dataCryptAES128(0, AES_KEY, nil, nil)
        let aesString = aesData.base64EncodedString()
        
        let charSet = CharacterSet.init(charactersIn: URL_Legal_Char_Set)
        let legalString = aesString.addingPercentEncoding(withAllowedCharacters: charSet)!
        
        let urlString = URL_TEST + "?data=" + legalString
        
        return urlString
    }
    
    //过滤掉重定向，并获取重定向url中的参数
    func revertPayURL(url :String) -> String {
        /*
       
        原始url https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx061108075783481bf9673bd01380036200&package=1019423356&redirect_url=http%3A%2F%2Ftestkmjkzx.kmwlyy.com%2Fweb%2Fzszg%2Findex.html%23%2Fpaycallback%3Fid%3D73b7f693d5ff4cd7897bdc5caf189ff5%26price%3D0.02
         
       解码特殊字符 https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx061108075783481bf9673bd01380036200&package=1019423356&redirect_url=http://testkmjkzx.kmwlyy.com/web/zszg/index.html#/paycallback?id=73b7f693d5ff4cd7897bdc5caf189ff5&price=0.02
       
     拼接新的url https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx061108075783481bf9673bd01380036200&package=1019423356&price=0.02
         */
        
        let decodeString = url.removingPercentEncoding
        let urlArr:[String] = decodeString!.components(separatedBy: "&redirect_url=")
        let mallOriginUrl = urlArr[1]
        let mallLegalUrl = mallOriginUrl.pregReplace(pattern: "#/paycallback", with: "")
        let components = URLComponents(url: URL.init(string: mallLegalUrl)!, resolvingAgainstBaseURL: true)
        
        let resultUrl = urlArr[0] + "&" + (components?.query)!
        
        return resultUrl
    }
}

extension MallViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopLoading()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard (url != nil) else {
            self.stopLoading()
            decisionHandler(.cancel)
            return
        }
        
        let absoluteString = navigationAction.request.url?.absoluteString
        print("链接:\(absoluteString ?? "为空")")
        
        // 跳转微信App
        if (absoluteString!.hasPrefix("weixin://wap/pay")) {
            let withApp = UIApplication.shared.canOpenURL(navigationAction.request.url!)
            if !withApp {
                let alert = UIAlertController.init(title: "提示", message: "请安装微信App以完成支付", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction.init(title: "安装", style: .default) { (action) in
                    let weChat_Itunes = URL.init(string: "https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8")
                    UIApplication.shared.openURL(weChat_Itunes!)
                }
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(navigationAction.request.url!)
            }
            
            decisionHandler(.cancel)
        }
        // 支付流程控制和回调处理
        else if (absoluteString!.hasPrefix("https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb")) {
            let header:Dictionary = navigationAction.request.allHTTPHeaderFields!
            let refere = header["Referer"]
            if (refere != nil && (refere == HOST_PAY || refere == HOST_PAY_A1)) {
                decisionHandler(.allow)
            } else {
                let newURL = revertPayURL(url: absoluteString!)
                var newRequest = URLRequest.init(url: URL.init(string: newURL)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
                newRequest.allHTTPHeaderFields = navigationAction.request.allHTTPHeaderFields
                newRequest.httpMethod = "GET"
                newRequest.setValue(HOST_PAY, forHTTPHeaderField: "Referer")
//                newRequest.setValue(HOST_PAY_A1, forHTTPHeaderField: "Referer")
                webView.load(newRequest)
                decisionHandler(.cancel)
            }
        }
        //wkwebview <a target="_blank"> 打不开链接的解决方案
        else if (navigationAction.targetFrame == nil) {
//            let url = navigationAction.request.url
//            let request = URLRequest.init(url: url!)
            webView.load(navigationAction.request)
            decisionHandler(.allow)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}

