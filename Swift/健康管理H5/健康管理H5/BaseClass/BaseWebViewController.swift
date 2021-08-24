//  WebViewController.swift
//  Created by mac on 2019/7/26.
//  Copyright © 2019 Gary. All rights reserved.
//
//  WebView控制器的基类

import UIKit
import WebKit

class BaseWebViewController: UIViewController {
    
    public var webTitle: String?
    public var hideNavBar: Bool = false //控制是否显示导航栏
    public var hideBackButton: Bool = false //控制是否显示返回按钮
    public let navBar = NavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: NavHeight))
    
    let webView = WKWebView.init()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func initWebView() {
        if !hideNavBar {
            navBar.viewController = self
            navBar.title = webTitle
            navBar.showBackButton = !hideBackButton
            self.view.addSubview(navBar)
        }
        
        let y_offset = !hideNavBar ? NavHeight:0.0
        let rect:CGRect = CGRect.init(x: 0, y: y_offset, width: self.view.frame.size.width, height: self.view.frame.size.height - y_offset)
        webView.frame = rect
        webView.allowsBackForwardNavigationGestures = true
        self.view.addSubview(webView)
        
        //解决状态栏空白问题
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        }
    }
    
    //! 子类调用此方式开始加载web
    func loadWebView(url: URL) {
        webView.load(URLRequest.init(url: url))
    }
    
    // 读取 message 里的 token 信息
    func handleAlertMessage(jsonStr: String) -> Dictionary<String, Any>? {
        let jsonData:Data = jsonStr.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return (dict as? Dictionary<String, Any>)
    }
}


