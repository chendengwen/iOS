//
//  Resource+Color.m
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "Resource+Color.h"

@implementation Resource (Color)

/********************  背景用色 ********************/
/*
 页面背景颜色  #ebebf4
 */
+ (UIColor *)viewBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xebebf4);
    });
    return color;
}
/*
 导航栏标题字体颜色，左右两边按钮字体颜色  0xffffff
 */
+ (UIColor *)navgationTitleColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xffffff);
    });
    return color;
}

/*
 导航栏背景颜色  0x3b96ff
 */
+ (UIColor *)navgationBackGroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x507AF8);
    });
    return color;
}

/******************** 文字用色 ********************/
/*!
 @brief cell标题的颜色 #434343
 */
+ (UIColor *)CellTitleColor{
    return UIColorFromRGB(0x434343);
}

/*!
 @brief cell副标题的颜色 #959595
 */
+ (UIColor *)CellSubTitleColor{
    return UIColorFromRGB(0x959595);
}


/******************** 副色调 --- 灰色 ********************/
/**
 *  淡淡灰的  #0xf1f1f1    首页cell的分割线
 */
+ (UIColor *)superLightGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf1f1f1);
    });
    return color;
}

/**
 *  浅灰的  #c3c3c3
 */
+ (UIColor *)lightGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xc3c3c3);
    });
    return color;
}

/**
 *  中度灰的  #0xd6d6d6
 */
+ (UIColor *)midGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xd6d6d6);
    });
    return color;
}
/**
 *  黑灰的  #0x2f3b4b
 */
+ (UIColor *)blackGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x2f3b4b);
    });
    return color;
}

/**
 *  浅黑色  #333333
 */
+ (UIColor *)lightBlackColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x333333);
    });
    return color;
}

/**
 *  灰黑色  #dadada
 */
+ (UIColor *)grayBlackColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xdadada);
    });
    return color;
}


/******************** 副色调 --- 彩色 ********************/
/**
 *  绿色
 */
+ (UIColor *)greenColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x51c140);
    });
    return color;
}

/**
 *  橙色  #f78600
 */
+ (UIColor *)orangeColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf78600);
    });
    return color;
}

/**
 *  蓝色  0x3b96ff
 */
+ (UIColor *)blueColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x3b96ff);
    });
    return color;
}

/**
 *  深蓝色  0x3b96ff
 */
+ (UIColor *)blueBlackColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x326C95);
    });
    return color;
}

/**
 *  黄色  0x3b96ff
 */
+ (UIColor *)yellowColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xFABD4C);
    });
    return color;
}





@end
