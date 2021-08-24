//
//  Resource+Image.m
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "Resource+Image.h"

@implementation Resource (Image)

#ifdef Device_iPad

static  NSString *GetAdaptImage(NSString *imageName){
    NSMutableString *realFileName;
    if (IS_IPAD_1_2){
        realFileName = [NSMutableString stringWithFormat:@"%@",imageName];
//        realFileName = [NSMutableString stringWithFormat:@"%@@2x",imageName];
    }else if (IS_IPAD_3_4){
        realFileName = [NSMutableString stringWithFormat:@"%@@3x",imageName];
    }else if (TARGET_IPHONE_SIMULATOR){
        realFileName = [NSMutableString stringWithString:imageName];
    }
    return realFileName;
}

#else

static  NSString *GetAdaptImage(NSString *imageName){
    NSMutableString *realFileName;
    if (IS_IPHONE_4_OR_LESS) {
        realFileName = [NSMutableString stringWithString:imageName];
    }else if (IS_IPHONE_5 || IS_IPHONE_6){
        realFileName = [NSMutableString stringWithFormat:@"%@@2x",imageName];
    }else if (IS_IPHONE_6P){
        realFileName = [NSMutableString stringWithFormat:@"%@@3x",imageName];
    }
    return realFileName;
}

#endif


// images.xcassets 里的文件是不在ipa包的根目录下的,这里的图都不是以图片格式存储在程序包里.而是以文件形式储存在Assets.car文件中,所以是不存在文件目录的
+ (UIImage *)imageWithImageName:(NSString *)imageName{
    NSString *path = [[NSBundle mainBundle] pathForResource:GetAdaptImage(imageName) ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageWithImageName:(NSString *)imageName type:(NSString *)imageType{
    NSString *path = [[NSBundle mainBundle] pathForResource:GetAdaptImage(imageName) ofType:imageType];
    return [UIImage imageWithContentsOfFile:path];
}


+ (UIImage *)logo{
    return [UIImage imageNamed:@"logo"];
}


/*
 *@brief  箭头
 */
+ (UIImage *)arrow_left{
    return [UIImage imageNamed:@"arrow_right"];
}

+ (UIImage *)arrow_right{
    return [UIImage imageNamed:@"arrow_right"];
}

+ (UIImage *)arrow_down{
    return [UIImage imageNamed:@"arrow_down"];
}

+ (UIImage *)arrow_up{
    return [UIImage imageNamed:@"arrow_up"];
}

+ (UIImage *)arrow_return{
    return [UIImage imageNamed:@"back"];
}


@end
