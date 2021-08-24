//
//  Resource+Color.h
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Resource.h"

@interface Resource (Color)

/*
 导航栏标题字体颜色，左右两边按钮字体颜色  0x000000
 */
+ (UIColor *)navgationTitleColor;

/*
 导航栏背景颜色  0x141d26
 */
+ (UIColor *)navgationBackGroundColor;

/*
 页面背景颜色  F7F8F0
 */
+ (UIColor *)viewBackgroundColor;

/*!
 @brief cell标题的颜色 #434343
 */
+ (UIColor *)CellTitleColor;

/*!
 @brief cell标题的颜色 #959595
 */
+ (UIColor *)CellSubTitleColor;


/******************** 副色调 --- 彩色 ********************/
/**
 *  绿色
 */
+ (UIColor *)greenColor;

/**
 *  橙色  #f78600
 */
+ (UIColor *)orangeColor;

/**
 *  蓝色  0x074f96
 */
+ (UIColor *)blueColor;

/**
 *  深蓝色  0x3b96ff
 */
+ (UIColor *)blueBlackColor;

/**
 *  黄色  0x3b96ff
 */
+ (UIColor *)yellowColor;


/******************** 副色调 --- 灰色 ********************/
/**
 *  淡淡灰的  #0xf1f1f1    首页cell的分割线
 */
+ (UIColor *)superLightGrayColor;

/**
 *  浅灰的  #0xeaeaea
 */
+ (UIColor *)lightGrayColor;

/**
 *  中度灰的  #0xd6d6d6
 */
+ (UIColor *)midGrayColor;


/**
 *  黑灰的  #0x2f3b4b
 */
+ (UIColor *)blackGrayColor;

/**
 *  浅黑色  #333333
 */
+ (UIColor *)lightBlackColor;

/**
 *  灰黑色  #dadada
 */
+ (UIColor *)grayBlackColor;

@end
