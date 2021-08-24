//
//  AppDelegate.m
//  YiYangCloud
//
//  Created by gary on 2017/4/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AppDelegate.h"
#import <WLRRoute/WLRRoute.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.router = [[WLRRouter alloc]init];
    // 保存UUID
    [UUID saveUUIDToKeyChain];
    //为输入框添加工具栏
    [IQKeyboardManager sharedManager].enable = YES;
    //点击屏幕收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //界面路由
    LaunchRouter *router = [[LaunchRouter alloc] init];
    [router installRootViewControllerIntoWindow:self.window];
    self.launchRouter = router;
    
    [self appearanceSetting];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}

-(void)appearanceSetting{
    // batButtonItem 文字颜色
    //    self.navigationBar.tintColor = [UIColor whiteColor];
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"arrow_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

@end
