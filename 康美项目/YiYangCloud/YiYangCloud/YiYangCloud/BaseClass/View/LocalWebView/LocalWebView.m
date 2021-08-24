//
//  LocalWebView.m
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "LocalWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WeakScriptMessageDelegate.h"

#define W_FunctionName      @"functionName"
#define W_BlockValue        @"blockValue"

@implementation LocalWebView
{
    NSMutableArray<NSDictionary<NSString*,NSString*>*> *_jsFuncArr;
    WeakScriptMessageDelegate *_weakDelegate;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _jsFuncArr = [NSMutableArray array];
        _weakDelegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _jsFuncArr = [NSMutableArray array];
        _weakDelegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    }
    return self;
}


- (void)dealloc
{
    for (NSString *funcName in _jsFuncArr) {
        [[self configuration].userContentController removeScriptMessageHandlerForName:funcName];
    }
    [_jsFuncArr removeAllObjects];
}

-(void)setCornerRadius:(float)cornerRadius{
    self.scrollView.layer.cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

-(void)loadFile:(NSString *)fileName delegate:(id)delegate{
    NSString * bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, fileName];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self loadWebViewURL:url delegate:delegate];
}

-(void)loadUrl:(NSString *)urlString delegate:(id)delegate{
    NSURL *url = [NSURL URLWithString:urlString];
    [self loadWebViewURL:url delegate:delegate];
    
//    NSString *httpHead = @"http://";
//    NSMutableString *temp = [NSMutableString stringWithString:urlString];
//    if ([urlString hasPrefix:httpHead]) {
//        [temp deleteCharactersInRange:NSMakeRange(0, httpHead.length)];
//    }
//    NSURL *url = [NSURL URLWithString:temp];
//    [self loadWebViewURL:url delegate:delegate];
}

-(void)loadWebViewURL:(NSURL *)url delegate:(id)delegate{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0a
    self.navigationDelegate = delegate;
    self.UIDelegate = delegate;
#else
    self.delegate = delegate;
#endif
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}

//OC注册供JS调用的方法
-(void)addContextFunction:( NSString *)functionName block:(ContextBlock)block{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDictionary *funcName_Block = @{W_FunctionName:functionName,
                                     W_BlockValue:block};
    
    // 查找相应functionName，如果方法定义过要跳过，重复定义会crash
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"functionName == %@",functionName];
    NSArray *results = [_jsFuncArr filteredArrayUsingPredicate:predicate];
    
    if (!(results && results.count > 0)) {
        [_jsFuncArr addObject:funcName_Block];
        [[self configuration].userContentController addScriptMessageHandler:_weakDelegate name:functionName];
    }
    
#else
    JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[functionName] = block;
#endif
}

//OC在JS调用方法做处理后的回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(controllerDidReceiveScriptMessage:)]) {
        [self.jsDelegate controllerDidReceiveScriptMessage:message];
    }else {
        // 在_jsFuncArr中根据funcName找到对应的block
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"functionName == %@",message.name];
        NSArray *results = [_jsFuncArr filteredArrayUsingPredicate:predicate];
        
        if (results && results.count > 0) {
            ContextBlock block = [[results lastObject] objectForKey:W_BlockValue];
            block();
        }
    }
    
}


/*// 1 ////// 图片缩放的js代码
 NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');";
 // 根据JS字符串初始化WKUserScript对象
 WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
 // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
 WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
 [config.userContentController addUserScript:script];
 _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
 [_webView loadHTMLString:@"<head></head><imgea src='http://www.nsu.edu.cn/v/2014v3/img/background/3.jpg' />"baseURL:nil];
 [self.view addSubview:_webView];
 
 // 2 ////// webView 执行JS代码 -- 用户调用用JS写过的代码
 //javaScriptString是JS方法名，completionHandler是异步回调block
 [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
 
 // 3 ////// JS调用App注册过的方法
 // 在WKWebView里面注册供JS调用的方法，是通过WKUserContentController类下面的方法
 [[_webView configuration].userContentController addScriptMessageHandler:self name:@"closeMe"];
 
 // 4 ////// JS调用OC方法后的回调
 - (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
 {
 NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
 }
 
 //JS: window.webkit.messageHandlers.closeMe.postMessage(null);
 */


@end
