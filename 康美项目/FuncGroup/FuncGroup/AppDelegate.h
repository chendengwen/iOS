//
//  AppDelegate.h
//  FuncGroup
//
//  Created by gary on 2017/2/6.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchRouter.h"

/*! 程序入口  */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) LaunchRouter *launchRouter;


@end

