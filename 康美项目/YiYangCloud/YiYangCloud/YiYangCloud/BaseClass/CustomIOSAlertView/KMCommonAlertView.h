//
//  KMCommonAlertView.h
//  InstantCare
//
//  Created by 朱正晶 on 16/5/25.
//  Copyright © 2016年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

/**
 *  通用警告View
 */
@interface KMCommonAlertView : UIView
/**
 *  标题
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/**
 *  显示在中间的标准提示信息标签
 */
@property (nonatomic, strong, readonly) UILabel *msgLabel;
/**
 *  放置在标题和按钮中间的自定义View
 */
@property (nonatomic, strong, readonly) UIView *customerView;
/**
 *  设置按钮标题，最多两个按钮
 */
@property (nonatomic, strong) NSArray *buttonsArray;
/**
 *  自动创建的按钮数组, 最多两个
 */
@property (nonatomic, strong, readonly) NSArray *realButtons;

@end
