//
//  LaunchRouter.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 页面路由 */
@interface LaunchRouter : NSObject

/**
 * 初始rootViewCtl
 */
- (void)installRootViewControllerIntoWindow:(UIWindow *)window;

/**
 * 切换rootViewCtl
 */
- (void)showRootViewController:(UIViewController *)viewController
                      inWindow:(UIWindow *)window;

@end
