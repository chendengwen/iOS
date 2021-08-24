//
//  AppDelegate.m
//  FuncGroup
//
//  Created by gary on 2017/2/6.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AppDelegate.h"
#import "UUID.h"
#import "DataBaseManager.h"
#import "PhotoManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 数据库
    [DataBaseManager sharedDataBaseManager];
    // 保存UUID
    [UUID saveUUIDToKeyChain];
    //为输入框添加工具栏
    [IQKeyboardManager sharedManager].enable = YES;
    //点击屏幕收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //界面路由
    LaunchRouter *router = [[LaunchRouter alloc] init];
    self.launchRouter = router;
    [[PhotoManager getInstance] setHengping];
    [self.launchRouter installRootViewControllerIntoWindow:self.window];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}

-(UIInterfaceOrientationMask) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if ( [[PhotoManager getInstance] isHengping] ) {
//        NSLog(@"横着的");
        return UIInterfaceOrientationMaskLandscape;
    }else{
//        NSLog(@"所有方向");
        return UIInterfaceOrientationMaskAll ;
    }
    
}
@end
