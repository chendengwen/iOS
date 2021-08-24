//
//  UIColor+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @brief 使用方法UIColorFromRGB(0x33aaff)
 */
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

/*!
 @brief 使用方法UIColorFromRGB(0x33aaff, 0.8f)
 */
#define UIColorFromRGBA(rgbValue, a) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:a]


@interface UIColor (Additions)

@end
