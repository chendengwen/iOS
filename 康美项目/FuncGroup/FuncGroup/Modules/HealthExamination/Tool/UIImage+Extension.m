//
//  UIImage+Extension.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 100;
    CGFloat imageH = 100;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  处理图片，缩小体积
 *
 *  @param image   原始图片
 *  @param quality 0.0 - 1
 *
 *  @return 缩小后的图片
 */
+ (UIImage *)scaleFromImage:(UIImage *)image compressionQuality:(CGFloat)quality
{
    NSData *data = UIImageJPEGRepresentation(image, quality);
    UIImage *newImage = [UIImage imageWithData:data];

    return newImage;
}


@end
