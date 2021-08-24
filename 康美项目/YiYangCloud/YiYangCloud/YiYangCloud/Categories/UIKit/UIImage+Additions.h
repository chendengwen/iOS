//
//  UIImage+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

//返回拉伸图片
+(UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;


/*!
 @brief     通过名称初始化UIImage对象, 但不缓存
 @param     name 图片名称, 图片必须位于程序目录下
 @return    UIImage对象
 */
+ (UIImage *)imageNamedWithNoCache:(NSString *)name;
/*!
 @brief     通过颜色创建图片，用于button点击纯色背景效果
 @param     color UIColor 颜色值
 @return    UIImage对象
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 @brief 将图片缩放到指定大小
 
 @param size 图片缩放后的大小
 
 @return 缩放后的UIImage对象
 */
- (UIImage *)rescaleImageToSize:(CGSize)size;
/**
 @brief 根据给定rect裁剪图片
 
 @param cropRect 需要裁剪的rect
 
 @return 裁剪后的UIImage对象
 */
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;
- (UIImage *)getUpImageFromImage:(float)upDistance;
/*!
 @brief     返回当前图的灰度图
 @return    返回当前图的灰度图
 */
- (UIImage*)grayImage;
/*!
 @brief     返回当前图的圆形图
 */
- (UIImage *)circleImage;


@end


@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
@end

@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

@end
