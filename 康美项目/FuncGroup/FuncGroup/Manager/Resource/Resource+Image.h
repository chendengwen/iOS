//
//  Resource+Image.h
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "Resource.h"

@interface Resource (Image)

+ (UIImage *)imageWithImageName:(NSString *)imageName;
+ (UIImage *)imageWithImageName:(NSString *)imageName type:(NSString *)imageType;



+ (UIImage *)logo;

/*
 *@brief  箭头
 */
+ (UIImage *)arrow_left;

+ (UIImage *)arrow_right;

+ (UIImage *)arrow_down;

+ (UIImage *)arrow_up;

+ (UIImage *)arrow_return;

@end
