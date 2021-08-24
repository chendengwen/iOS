//
//  UIImageView+Addtions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>



@interface UIImageView (Addtions)

/*!
 @brief     设置/替换图片时，执行淡入淡出动画， 默认时间0.25s
 @param     image 需要设置/替换的图片对象
 @param     animated 是否开启动画
 */
- (void)setImage:(UIImage *)image animated:(BOOL)animated;
/**
 @brief 根据给定时间， 淡入淡出动画设置/替换图片
 
 @param image    需要设置/替换的图片对象
 @param duration 动画时长，单位秒
 */
- (void)setImage:(UIImage *)image duration:(NSTimeInterval)duration;


@end
