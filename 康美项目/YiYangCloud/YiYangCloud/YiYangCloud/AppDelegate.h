//
//  AppDelegate.h
//  YiYangCloud
//
//  Created by gary on 2017/4/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchRouter.h"
@class WLRRouter;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)WLRRouter * router;
@property (nonatomic, strong) LaunchRouter *launchRouter;

@end

