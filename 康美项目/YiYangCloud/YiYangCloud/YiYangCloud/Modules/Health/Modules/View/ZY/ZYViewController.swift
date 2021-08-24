//
//  ZYViewController.swift
//  YiYangCloud
//
//  Created by zhong on 2017/4/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import NJKWebViewProgress
class ZYViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var progressView:NJKWebViewProgressView?
    
    var progressProxy:NJKWebViewProgress?
    
    var urlString:String?
    
    var titleString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        loadLoginPage ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.addSubview(progressView!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        progressView!.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ZYViewController {
    //加载用户登录页面
    func loadLoginPage () {
        
        progressProxy = NJKWebViewProgress.init()
        self.webView.delegate = progressProxy
        progressProxy?.webViewProxyDelegate = self
        progressProxy?.progressDelegate = self
        let progressBarHeight:CGFloat = 2.0;
        let navigationBarBounds:CGRect = self.navigationController!.navigationBar.bounds;
        
        let barFrame:CGRect = CGRect.init(x: 0, y: navigationBarBounds.size.height - progressBarHeight, width: navigationBarBounds.size.width, height: progressBarHeight);
        /* var components = calendar.dateComponents(NSSet.init(objects: Calendar.Component.year,Calendar.Component.month,Calendar.Component.day) as! Set<Calendar.Component>, from: now)*/
        progressView = NJKWebViewProgressView.init(frame: barFrame)
        progressView?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        //获取登录的网页的url
        if (urlString?.hasPrefix("http"))! {
            urlString = (urlString?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed))!
        }else {
            urlString = "http://10.2.20.234:8080/#\((urlString?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed))!)"
        }
        let url = URL(string:urlString!)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
}

extension ZYViewController:UIWebViewDelegate, NJKWebViewProgressDelegate{
    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        progressView?.setProgress(progress, animated: true)
        self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
}
