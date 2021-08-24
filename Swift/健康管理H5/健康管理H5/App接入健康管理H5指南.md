##  使用说明

####一、页面样式
```
主色: #008dfd
字体: "Microsoft YaHei" 大小根据屏幕自适应
导航高度: 
    齐刘海-70px；
    无刘海-64px；
```

####二、js事件回调
传参方式是使用alert()方法，参数形式为字符串，有以下4种事件类型：

```
gotoNative -- 'X'关闭按钮点击后退出H5页面
gotoShoppingMall -- 原生跳转到健康商城
gotoOuterSiteURL -- 跳转到外部站点
gotoDoctorOnline -- 在线问诊
```
示例

``` 
{
    'action': 'gotoOuterSiteURL',
    'title': '中医体质',
    'url': 'www.baidu.com'
}

{
    'action': 'gotoShoppingMall',
    'title': '商品详情',
    'url': 'www.baidu.com',
    'params': { gooID: 21345 }
}
```

####三、iOS webView加载注意点
1、 状态栏空白问题

```
    if #available(iOS 11.0, *) {
        webView.scrollView.contentInsetAdjustmentBehavior = .never
    }else{
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
```

2、 接收js的alert()回调

```
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // 读取 message 里的 token 信息
        let jsonData:Data = message.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        if dict != nil {

        }
        completionHandler()
    }
```
####四、接入商城(商城首页、商品详情)
1、 获取商城首页链接

    i. 构建参数
    {
        'orgId': 'ZSZG',
        'openId': person.Data.ID,
        'telPhone': person.Data.PhoneNumber,
        'groupId': 'a28dc233c40944b9b689f110dfb11a26',
        'time': timeIntervalSince1970*1000
    }

    ii. 参数加密、UTF8转码非法字符 
        a. 键值对参数序列化为JSON字符串;
        b. 将JSON字符串`AES128`加密，加密后的二进制数据以Base64格式转回字符串;
        c. 将Base64字符串中数字字母以外的字符做百分比符号转义，以生成合法的URL参数;

    iii. 拼接完整链接：
        HOST + "?data=" + Base64-String
        a. Test_HOST = "http://testkmjkzx.kmwlyy.com/web/shop/o2o/index/userAuthenticationGet"
        b. Release_HOST = "http://kmjkzx.kmwlyy.com/web/shop/o2o/index/userAuthenticationGet"

2、 获取商品详情链接
- 步骤同上，构建参数时需要添加如下两个参数：

```
    'DETAIL': 'action',
    'actionData': 商品id
```

3、**iOS**支付 -- 在商城的H5页面上点击确认支付

    i. 先判断是否有安装相应的支付软件，没有的话可以跳转到app下载链接或者做文字提示

    ii. 已安装相应的支付软件，直接使用当前商城H5页面导航器的url链接打开App开启支付
    UIApplication.shared.canOpenURL(navigationAction.request.url!)

    iii. 支付完成后会在AppDelegate中接收到回调

```
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.contains("a1.kmwlyy.com") || url.absoluteString.contains("kmjkgl.com") {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification_PaySuccess), object: nil)
        }
        return true
    }
```

    iiii.收到回调后需要通知商城H5页面重定向到支付完成页面。

    - 在点击确认支付后，H5会一直通过链接“https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb” 轮询支付是否完成;
      支付回调域名
      a. HOST_PAY    = "kmjkgl.com://"
      b. HOST_PAY_A1 = "a1.kmwlyy.com://"

    - 未完成时webView导航器要禁止页面跳转，直到App收到支付完成的通知后，添加指定参数到轮询链接中再允许轮询链接跳转:

```
    if (url?.hasPrefix("https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"))! {

        let header:Dictionary = navigationAction.request.allHTTPHeaderFields!
        let refere = header["Referer"]

        if (refere != nil && (refere == HOST_PAY || refere == HOST_PAY_A1)) {
            decisionHandler(.allow)
        } else {
            let newURL = revertPayURL(url: url!)
            var newRequest = URLRequest.init(url: URL.init(string: newURL)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
            newRequest.allHTTPHeaderFields = navigationAction.request.allHTTPHeaderFields
            newRequest.httpMethod = "GET"
            newRequest.setValue(HOST_PAY, forHTTPHeaderField: "Referer")
            webView.load(newRequest)
            decisionHandler(.cancel)
        }
    }
```  

