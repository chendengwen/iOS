//
//  XYAlertView.h
//  FuncGroup
//
//  Created by zhong on 2017/2/17.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYAlertView : UIView

@property (nonatomic,assign) CGFloat height;
/**
 *  标题
 */
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  显示在中间的标准提示信息标签
 */
@property (nonatomic, weak) UILabel *msgLabel;
/**
 *  放置在标题和按钮中间的自定义View
 */
@property (nonatomic, weak) UIView *customerView;
/**
 *  设置按钮标题，最多两个按钮
 */
@property (nonatomic, strong) NSArray *buttonsArray;
/**
 *  设置输入框标题，最多两个输入框
 */
@property (nonatomic, strong) NSArray *textsArray;
/**
 *  设置输入框标题，最多两个输入框
 */
@property (nonatomic, strong) NSArray *textsTitleArray;
/**
 *  自动创建的输入框数组, 最多两个
 */
@property (nonatomic, strong,) NSArray *realTexts;
/**
 *  自动创建的按钮数组, 最多两个
 */
@property (nonatomic, strong, readonly) NSArray *realButtons;

- (void)dismiss;
@end
