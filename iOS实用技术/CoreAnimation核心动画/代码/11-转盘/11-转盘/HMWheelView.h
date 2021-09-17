//
//  HMWheelView.h
//  11-转盘
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMWheelView : UIView

+ (instancetype)wheelView;

// 开始旋转
- (void)startRotating;

// 停止旋转
- (void)stopRotating;

@end
