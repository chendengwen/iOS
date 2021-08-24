//
//  KMSwitch2.h
//  YiYangCloud
//
//  Created by Cary on 2017/5/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSwitch : UIControl

@property (nonatomic, assign, getter = isOn) BOOL on;

@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSString *onText;
@property (nonatomic, strong) NSString *offText;

@property (nonatomic, strong) NSString *text;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
