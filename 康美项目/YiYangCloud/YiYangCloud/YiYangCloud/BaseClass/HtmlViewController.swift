//
//  HtmlViewController.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/9.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

protocol JSDelegate {
    
    func controllerDidReceiveScriptMessage(message:WKScriptMessage)
    
}

class HtmlViewController: UIViewController {
    
    open var fileName:String?
    let webView = LocalWebView.init(frame: CGRect(x:0,y:0,width:SCREENWIDTH,height:SCREENHEIGHT - NavHeight))
    fileprivate let progressView = UIProgressView.init(frame: CGRect(x:0,y:0,width:SCREENWIDTH,height:0))
    fileprivate let observerKeyPath = "estimatedProgress"
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        webView.addObserver(self, forKeyPath: observerKeyPath, options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        webView.addObserver(self, forKeyPath: observerKeyPath, options: .new, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.title ?? (self.paramDic["title"]) as! String
        
        self.view.addSubview(webView)
        
        
        self.view.addSubview(progressView)
        progressView.tintColor = UIColor.orange
        progressView.trackTintColor = UIColor.white
        
        if self.fileName != nil {
            webView.loadFile(fileName, delegate: self)
        } else if self.paramDic != nil && self.paramDic["fileName"] != nil {
            webView.loadFile(self.paramDic["fileName"] as! String, delegate: self)
        } else if self.paramDic != nil && self.paramDic["url"] != nil {
            webView.loadUrl(self.paramDic["url"] as! String, delegate: self)
        }
        
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? LocalWebView === webView && keyPath == observerKeyPath {
            let newprogress = change?[.newKey] as! Float
            if (newprogress >= 1.0) {
                progressView.isHidden = true
                progressView.setProgress(0.0, animated: false)
            }else {
                progressView.isHidden = false
                progressView.setProgress(newprogress, animated: true)
            }
        }

    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: observerKeyPath)
        
    }
}

extension HtmlViewController:JSDelegate {
    func controllerDidReceiveScriptMessage(message: WKScriptMessage) {}
}

// 加载的状态回调 & 页面跳转的代理方法
extension HtmlViewController:WKNavigationDelegate {
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
    
    // 接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //#warning 使用WKNavigationActionPolicyCancel策略后出现 Error Domain=WebKitErrorDomain Code=101 的错误
        decisionHandler(.allow)
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension HtmlViewController:WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return webView
    }
    
    /**
     *  web界面中有弹出警告框时调用
     *
     *  @param webView           实现该代理的webview
     *  @param message           警告框中的内容
     *  @param frame             主窗口
     *  @param completionHandler 警告框消失调用
     */
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}
