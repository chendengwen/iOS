//  WebViewController.swift
//
//  Created by mac on 2019/7/26.
//  Copyright © 2019 Gary. All rights reserved.
//
//  H5页面主页

import UIKit
import WebKit

enum WebAction: String {
    case gotoNative = "gotoNative"  // 退出H5页面
    case gotoShoppingMall = "gotoShoppingMall"  // 商城或者商品详情
    case gotoOuterSiteURL = "gotoOuterSiteURL"  // 跳转到外部站点
    case gotoDoctorOnline = "gotoDoctorOnline"  // 在线问诊
}

class HomeViewController: BaseWebViewController {
    
    var url: String?
    private var loaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        hideNavBar = true
        
        initWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        var urlObj:URL
        if url!.hasPrefix("http") {
            urlObj = URL.init(string: url!)!
        } else {
            urlObj = URL.init(fileURLWithPath: url!)
        }
        loadWebView(url: urlObj)
    }
}

extension HomeViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // 读取 message 里的 token 信息
        let jsonData:Data = message.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        if dict != nil {
            let dataDict = dict as! NSDictionary
            let keyArr = dataDict.allKeys as! Array<String>
            let containsAction = keyArr.contains { $0 == "action" }
            
            if containsAction {
                let action = WebAction(rawValue: dataDict.object(forKey: "action") as! String)!
                
                switch action {
                    case .gotoNative:
                        self.navigationController?.popToRootViewController(animated: true)
                    
                    case .gotoShoppingMall:
                        let mallCtl = MallViewController()
                        
                        if let params = dataDict.object(forKey: "params") as? [String : Any]{
                            mallCtl.goodsID = "\(params["gooID"] ?? "")"
                            mallCtl.webTitle = (dataDict.object(forKey: "title") as! String)
                            self.navigationController?.pushViewController(mallCtl, animated: true)
                        } else {
                            mallCtl.webTitle = "健康商城"
                            self.navigationController?.pushViewController(mallCtl, animated: true)
                        }
                    
                    case .gotoOuterSiteURL:
                        let title = dataDict.object(forKey: "title") as! String
                        let urlValue = dataDict.object(forKey: "url")
                        if (urlValue == nil || urlValue is NSNull || (urlValue as! String).isEmpty) {
                            let alert = UIAlertController.init(title: "提示", message: "没有传入跳转路径", preferredStyle: .alert)
                            let okAction = UIAlertAction.init(title: "确定", style: .default)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            break
                        }
//                        NSLog("\(title)---\(url)")
                        let url = urlValue as! String
                        
                        let urlAbsoluteString:String = webView.url!.absoluteString.removingPercentEncoding!
                        let webCtl = BaseWebViewController()
                        webCtl.webTitle = title

                        var tmpUrlObj:URL? = nil
                        // 根据是加载本地还是线上区分url处理
                        if (url.contains("http://")) {
                            tmpUrlObj = URL.init(string: url)!
                        } else if url.containsIP() && !url.contains("http://") {
                            tmpUrlObj = URL.init(string: "http://" + url)!
                        } else if (urlAbsoluteString.hasPrefix("file://")) {
                            let relativePath = webView.url!.relativePath.pregReplace(pattern: "/index.html", with: "")
                            tmpUrlObj = URL.init(fileURLWithPath: relativePath + url)
                        }
                        webCtl.initWebView()
                        webCtl.loadWebView(url: tmpUrlObj!)
                        
                        self.navigationController?.pushViewController(webCtl, animated: true)
                    case .gotoDoctorOnline:
                        // 跳转到在线问诊
                        let alert = UIAlertController.init(title: "提示", message: "在线问诊还未接入", preferredStyle: .alert)
                        let okAction = UIAlertAction.init(title: "确定", style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        break;
                }
            }
            
        }
        
        completionHandler()
    }
}

extension HomeViewController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !loaded {
            loaded = true
            
            let setTokenScript_H5 = "localStorage.setItem('token_H5', \'\(UserInfoModel.shareCache.token_H5!)\')"
            let setTokenScript_App = "localStorage.setItem('token_360App', \'\(UserInfoModel.shareCache.token_360App!)\')"
            webView.evaluateJavaScript(setTokenScript_H5)
            webView.evaluateJavaScript(setTokenScript_App)
            
            webView.reload()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}


