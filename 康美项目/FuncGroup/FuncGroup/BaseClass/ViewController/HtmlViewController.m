//
//  HtmlViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HtmlViewController.h"


@interface HtmlViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>
{
    LocalWebView *_webView;
}
@end

@implementation HtmlViewController

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNaviBarViewWithTitle:self.title?:self.paramDic[@"title"]];
    
    _webView = [[LocalWebView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH , SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_webView];
    
    if (self.fileName) {
        [_webView loadFile:self.fileName delegate:self];
    }else if (self.paramDic && self.paramDic[kFileName] != nil) {
        [_webView loadFile:self.paramDic[kFileName] delegate:self];
    }else if (self.paramDic && self.paramDic[kUrl] != nil) {
        [_webView loadUrl:self.paramDic[kUrl] delegate:self];
    }
}

#pragma mark === UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

#pragma mark === WKNavigationDelegate 加载的状态回调
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD showWithStatus:@"正在加载..."];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [SVProgressHUD dismiss];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

#pragma mark === WKNavigationDelegate 页面跳转的代理方法

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//#warning 使用WKNavigationActionPolicyCancel策略后出现 Error Domain=WebKitErrorDomain Code=101 的错误
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    // 网页上所有的_blank标签都去掉
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
//    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark === WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return webView;
}
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler{

}

#pragma mark === JSDelegate
-(void)controllerDidReceiveScriptMessage:(WKScriptMessage *)message{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
