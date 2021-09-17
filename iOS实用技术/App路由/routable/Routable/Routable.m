//
//  Routable.m
//  Routable
//
//  Created by Clay Allsopp on 4/3/13.
//  Copyright (c) 2013 TurboProp Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Routable.h"

@implementation Routable

+ (instancetype)sharedRouter {
    static Routable *_sharedRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRouter = [[Routable alloc] init];
    });
    return _sharedRouter;
}

//really unnecessary; kept for backward compatibility.
+ (instancetype)newRouter {
    return [[self alloc] init];
}

@end

// 每个路由类对应一个RouterParams
@interface RouterParams : NSObject

@property (readwrite, nonatomic, strong) UPRouterOptions *routerOptions;
@property (readwrite, nonatomic, strong) NSDictionary *openParams;  // 执行open方法的时候在url里带的参数
@property (readwrite, nonatomic, strong) NSDictionary *extraParams; // 执行open方法的时候传的extraParams参数
@property (readwrite, nonatomic, strong) NSDictionary *controllerParams; // 把路由对象的所有参数生成统一的NSDictionary

@end

@implementation RouterParams

- (instancetype)initWithRouterOptions: (UPRouterOptions *)routerOptions openParams: (NSDictionary *)openParams extraParams: (NSDictionary *)extraParams{
    [self setRouterOptions:routerOptions];
    [self setExtraParams: extraParams];
    [self setOpenParams:openParams];
    return self;
}

- (NSDictionary *)controllerParams {
    NSMutableDictionary *controllerParams = [NSMutableDictionary dictionaryWithDictionary:self.routerOptions.defaultParams];
    [controllerParams addEntriesFromDictionary:self.extraParams];
    [controllerParams addEntriesFromDictionary:self.openParams];
    return controllerParams;
}
//fake getter. Not idiomatic Objective-C. Use accessor controllerParams instead
- (NSDictionary *)getControllerParams {
    return [self controllerParams];
}
@end

@interface UPRouterOptions ()

@property (readwrite, nonatomic, strong) Class openClass;
@property (readwrite, nonatomic, copy) RouterOpenCallback callback;
@end

@implementation UPRouterOptions

//Explicit construction
+ (instancetype)routerOptionsWithPresentationStyle: (UIModalPresentationStyle)presentationStyle
                                   transitionStyle: (UIModalTransitionStyle)transitionStyle
                                     defaultParams: (NSDictionary *)defaultParams
                                            isRoot: (BOOL)isRoot
                                           isModal: (BOOL)isModal {
    UPRouterOptions *options = [[UPRouterOptions alloc] init];
    options.presentationStyle = presentationStyle;
    options.transitionStyle = transitionStyle;
    options.defaultParams = defaultParams;
    options.shouldOpenAsRootViewController = isRoot;
    options.modal = isModal;
    options.html = NO;
    return options;
}
//Default construction; like [NSArray array]
+ (instancetype)routerOptions {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:NO];
}

//Custom class constructors, with heavier Objective-C accent
+ (instancetype)routerOptionsAsModal {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:YES];
}
+ (instancetype)routerOptionsWithPresentationStyle:(UIModalPresentationStyle)style {
    return [self routerOptionsWithPresentationStyle:style
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:NO];
}
+ (instancetype)routerOptionsWithTransitionStyle:(UIModalTransitionStyle)style {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:style
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:NO];
}
+ (instancetype)routerOptionsForDefaultParams:(NSDictionary *)defaultParams {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:defaultParams
                                             isRoot:NO
                                            isModal:NO];
}
+ (instancetype)routerOptionsAsRoot {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:YES
                                            isModal:NO];
}

//Exposed methods previously supported
+ (instancetype)modal {
    return [self routerOptionsAsModal];
}
+ (instancetype)withPresentationStyle:(UIModalPresentationStyle)style {
    return [self routerOptionsWithPresentationStyle:style];
}
+ (instancetype)withTransitionStyle:(UIModalTransitionStyle)style {
    return [self routerOptionsWithTransitionStyle:style];
}
+ (instancetype)forDefaultParams:(NSDictionary *)defaultParams {
    return [self routerOptionsForDefaultParams:defaultParams];
}
+ (instancetype)forHTML:(BOOL)isHtml {
    UPRouterOptions *options = [self routerOptionsWithTransitionStyle:UIModalTransitionStyleCoverVertical];
    options.html = isHtml;
    return options;
}
+ (instancetype)root {
    return [self routerOptionsAsRoot];
}

//Wrappers around setters (to continue DSL-like syntax)
- (UPRouterOptions *)modal {
    [self setModal:YES];
    return self;
}
- (UPRouterOptions *)withPresentationStyle:(UIModalPresentationStyle)style {
    [self setPresentationStyle:style];
    return self;
}
- (UPRouterOptions *)withTransitionStyle:(UIModalTransitionStyle)style {
    [self setTransitionStyle:style];
    return self;
}
- (UPRouterOptions *)forDefaultParams:(NSDictionary *)defaultParams {
    [self setDefaultParams:defaultParams];
    return self;
}
- (UPRouterOptions *)root {
    [self setShouldOpenAsRootViewController:YES];
    return self;
}
@end

@interface UPRouter ()

// Map of URL format NSString -> RouterOptions
// i.e. "users/:id"
@property (readwrite, nonatomic, strong) NSMutableDictionary *routes;
// Map of final URL NSStrings -> RouterParams
// i.e. "users/16"
@property (readwrite, nonatomic, strong) NSMutableDictionary *cachedRoutes;

@end

#define ROUTE_NOT_FOUND_FORMAT @"No route found for URL %@"
#define INVALID_CONTROLLER_FORMAT @"Your controller class %@ needs to implement either the static method %@ or the instance method %@"

@implementation UPRouter

- (id)init {
    if ((self = [super init])) {
        self.routes = [NSMutableDictionary dictionary];
        self.cachedRoutes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback {
    [self map:format toCallback:callback withOptions:nil];
}

- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback withOptions:(UPRouterOptions *)options {
    if (!format) {
        @throw [NSException exceptionWithName:@"RouteNotProvided"
                                       reason:@"Route #format is not initialized"
                                     userInfo:nil];
        return;
    }
    if (!options) {
        options = [UPRouterOptions routerOptions];
    }
    options.callback = callback;
    [self.routes setObject:options forKey:format];
}

- (void)map:(NSString *)format toController:(Class)controllerClass {
    [self map:format toController:controllerClass withOptions:nil];
}

// 注册时只存储 UPRouterOptions
- (void)map:(NSString *)format toController:(Class)controllerClass withOptions:(UPRouterOptions *)options {
    if (!format) {
        @throw [NSException exceptionWithName:@"RouteNotProvided"
                                       reason:@"Route #format is not initialized"
                                     userInfo:nil];
        return;
    }
    if (!options) {
        options = [UPRouterOptions routerOptions];
    }
    options.openClass = controllerClass;
    [self.routes setObject:options forKey:format];
}

- (void)openExternal:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)open:(NSString *)url {
    [self open:url animated:YES];
}

- (void)open:(NSString *)url animated:(BOOL)animated {
    [self open:url animated:animated extraParams:nil];
}

- (void)open:(NSString *)url
    animated:(BOOL)animated
 extraParams:(NSDictionary *)extraParams
{
    // 根据 url 和 extraParams 还有注册时缓存的UPRouterOptions，生成统一格式的 RouterParams
    RouterParams *params = [self routerParamsForUrl:url extraParams: extraParams];
    UPRouterOptions *options = params.routerOptions;
    
    // 是函数包路由的话就处理包
    if (options.callback) {
        RouterOpenCallback callback = options.callback;
        callback([params controllerParams]);
        return;
    }
    
    if (!self.navigationController) {
        if (_ignoresExceptions) {
            return;
        }
        
        @throw [NSException exceptionWithName:@"NavigationControllerNotProvided"
                                       reason:@"Router#navigationController has not been set to a UINavigationController instance"
                                     userInfo:nil];
    }
    
    // 此初始化步骤以及包含了传值给控制器，控制器需要实现 +allocWithRouterParams 或 -initWithRouterParams 方法
    UIViewController *controller = [self controllerForRouterParams:params];
    
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    
    if ([options isModal]) {
        if ([controller.class isSubclassOfClass:UINavigationController.class]) {
            [self.navigationController presentViewController:controller
                                                    animated:animated
                                                  completion:nil];
        }
        else {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            navigationController.modalPresentationStyle = controller.modalPresentationStyle;
            navigationController.modalTransitionStyle = controller.modalTransitionStyle;
            [self.navigationController presentViewController:navigationController
                                                    animated:animated
                                                  completion:nil];
        }
    }
    else if (options.shouldOpenAsRootViewController) {
        [self.navigationController setViewControllers:@[controller] animated:animated];
    }
    else {
        [self.navigationController pushViewController:controller animated:animated];
    }
}

- (NSDictionary*)paramsOfUrl:(NSString*)url {
    return [[self routerParamsForUrl:url] controllerParams];
}

//Stack operations
- (void)popViewControllerFromRouterAnimated:(BOOL)animated {
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)pop {
    [self popViewControllerFromRouterAnimated:YES];
}

- (void)pop:(BOOL)animated {
    [self popViewControllerFromRouterAnimated:animated];
}

///////
- (RouterParams *)routerParamsForUrl:(NSString *)url extraParams: (NSDictionary *)extraParams {
    if (!url) {
        //if we wait, caching this as key would throw an exception
        if (_ignoresExceptions) {
            return nil;
        }
        @throw [NSException exceptionWithName:@"RouteNotFoundException"
                                       reason:[NSString stringWithFormat:ROUTE_NOT_FOUND_FORMAT, url]
                                     userInfo:nil];
    }
    
    // 没有在打开页面时添加新的参数时直接读取缓存
    // 1.url路径没变，其中的参数也没变 2.没有 extraParams 参数
    if ([self.cachedRoutes objectForKey:url] && !extraParams) {
        return [self.cachedRoutes objectForKey:url];
    }
    
    NSArray *givenParts = url.pathComponents;
    NSArray *legacyParts = [url componentsSeparatedByString:@"/"];
    if ([legacyParts count] != [givenParts count]) {
        NSLog(@"Routable Warning - your URL %@ has empty path components - this will throw an error in an upcoming release", url);
        givenParts = legacyParts;
    }
    
    __block RouterParams *openParams = nil;
    // 在 Routable 的 routes（NSString -> RouterOptions）路由注册表中查找并匹配此时正开启的url
    [self.routes enumerateKeysAndObjectsUsingBlock:
     ^(NSString *routerUrl, UPRouterOptions *routerOptions, BOOL *stop) {
         
         NSArray *routerParts = [routerUrl pathComponents];
         // 筛选条件（url段个数相等才能进入匹配流程，所以url里的参数都是必填的）
         if ([routerParts count] == [givenParts count]) {
             
             // 注册的路由url 和 open使用的url切割后一个一个地匹配参数
             // !!! open的url的参数必须与注册的url一致，多传参数或少传参都会报错
             NSDictionary *givenParams = [self paramsForUrlComponents:givenParts routerUrlComponents:routerParts];
             if (givenParams) {
                 // 提取完url里的参数 然后重新生成 RouterParams
                 openParams = [[RouterParams alloc] initWithRouterOptions:routerOptions openParams:givenParams extraParams: extraParams];
                 *stop = YES;
             }
         }
     }];
    
    if (!openParams) {
        if (_ignoresExceptions) {
            return nil;
        }
        @throw [NSException exceptionWithName:@"RouteNotFoundException"
                                       reason:[NSString stringWithFormat:ROUTE_NOT_FOUND_FORMAT, url]
                                     userInfo:nil];
    }
    
    // 缓存或是更新缓存
    [self.cachedRoutes setObject:openParams forKey:url];
    return openParams;
}

- (RouterParams *)routerParamsForUrl:(NSString *)url {
    return [self routerParamsForUrl:url extraParams: nil];
}

- (NSDictionary *)paramsForUrlComponents:(NSArray *)givenUrlComponents
                     routerUrlComponents:(NSArray *)routerUrlComponents {
    
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [routerUrlComponents enumerateObjectsUsingBlock:
     ^(NSString *routerComponent, NSUInteger idx, BOOL *stop) {
         
         NSString *givenComponent = givenUrlComponents[idx];
         if ([routerComponent hasPrefix:@":"]) {
             NSString *key = [routerComponent substringFromIndex:1];
             [params setObject:givenComponent forKey:key];
         }
         // 有组件名不一样时停止枚举 ---- 组件名不一样说明注册或调用有地方写错了
         else if (![routerComponent isEqualToString:givenComponent]) {
             params = nil;
             *stop = YES;
         }
     }];
    return params;
}

- (UIViewController *)controllerForRouterParams:(RouterParams *)params {
    SEL CONTROLLER_CLASS_SELECTOR = sel_registerName("allocWithRouterParams:");
    SEL CONTROLLER_SELECTOR = sel_registerName("initWithRouterParams:");
    UIViewController *controller = nil;
    Class controllerClass = params.routerOptions.openClass;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([controllerClass respondsToSelector:CONTROLLER_CLASS_SELECTOR]) {
        controller = [controllerClass performSelector:CONTROLLER_CLASS_SELECTOR withObject:[params controllerParams]];
    }
    else if ([params.routerOptions.openClass instancesRespondToSelector:CONTROLLER_SELECTOR]) {
        // 注意这种写法--相当有趣
        controller = [[params.routerOptions.openClass alloc] performSelector:CONTROLLER_SELECTOR withObject:[params controllerParams]];
    }
#pragma clang diagnostic pop
    if (!controller) {
        if (_ignoresExceptions) {
            return controller;
        }
        @throw [NSException exceptionWithName:@"RoutableInitializerNotFound"
                                       reason:[NSString stringWithFormat:INVALID_CONTROLLER_FORMAT, NSStringFromClass(controllerClass), NSStringFromSelector(CONTROLLER_CLASS_SELECTOR),  NSStringFromSelector(CONTROLLER_SELECTOR)]
                                     userInfo:nil];
    }
    
    controller.modalTransitionStyle = params.routerOptions.transitionStyle;
    controller.modalPresentationStyle = params.routerOptions.presentationStyle;
    return controller;
}

@end

