//
//  UIViewController+KMRoute.h
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMRouteRequest;
@interface UIViewController (KMRoute)

@property (strong,nonatomic) KMRouteRequest *routeRequest;

@end
