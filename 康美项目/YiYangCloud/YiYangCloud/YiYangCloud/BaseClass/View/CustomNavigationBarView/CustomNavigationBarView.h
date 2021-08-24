//
//  CustomNavigationBarView.h
//  PMH.Views
//
//  Created by 登文 陈 on 14-7-30.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Rect_64                          CGRectMake(0,0,SCREEN_WIDTH,64.f)


/**
 *  展示类型
 */
typedef NS_ENUM(NSInteger, NavigationBarViewBackColor)
{
    NavigationBarViewBackColorWhite,
    NavigationBarViewBackColorBlack
};


@interface CustomNavigationBarView : UIView
{
//    CGFloat _title_Y;
//    CGFloat _underLine_Y;
    CGFloat _Y_Y;  // 20的差值
}

@property(nonatomic,strong) UILabel *titleLab;

@property(nonatomic,copy) NSString *title;

@property(nonatomic,copy) UIImage *leftImage;

@property(nonatomic,copy) UIImage *rightImage;

@property(nonatomic,assign) NavigationBarViewBackColor barCOlor;


-(id)initWithTitle:(NSString *)title withBackColorStyle:(NavigationBarViewBackColor)colorStyle;

-(id)initWithTitle:(NSString *)title withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle;

-(id)initWithTitleImgView:(NSString *)imgString withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle;
@end
