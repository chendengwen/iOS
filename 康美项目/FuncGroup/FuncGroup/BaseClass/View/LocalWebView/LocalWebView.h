//
//  LocalWebView.h
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JSDelegate.h"

typedef void (^ContextBlock)(void);

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
@interface LocalWebView : WKWebView<WKScriptMessageHandler>
#else
@interface LocalWebView : UIWebView<UIWebViewDelegate>
#endif

/*
 * js代理如果不需要单独指定就不需要设置，要单独设置回调时设置，需要实现相应协议
 */
@property (nonatomic,assign) id<JSDelegate,WKScriptMessageHandler> jsDelegate;

@property (nonatomic,assign) float cornerRadius;

/*
 * 加载本地文件并设置代理
 */
-(void)loadFile:(NSString *)fileName delegate:(id)delegate;

/*
 * 加载文件文件并设置代理
 */
-(void)loadUrl:(NSString *)urlString delegate:(id)delegate;

/*
 * js上下文添加OC原生方法
 * functionName所对应方法在js里调用，在webview的context里实现
 */
-(void)addContextFunction:(NSString *)functionName block:(ContextBlock)block;

@end
