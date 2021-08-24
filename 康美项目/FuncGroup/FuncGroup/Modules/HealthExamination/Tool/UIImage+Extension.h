//
//  UIImage+Extension.h
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  处理图片，缩小体积
 *
 *  @param image   原始图片
 *  @param quality 0.0 - 1
 *
 *  @return 缩小后的图片
 */
+ (UIImage *)scaleFromImage:(UIImage *)image compressionQuality:(CGFloat)quality;

@end
