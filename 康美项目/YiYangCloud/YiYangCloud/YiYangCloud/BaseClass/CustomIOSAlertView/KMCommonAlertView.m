//
//  KMCommonAlertView.m
//  InstantCare
//
//  Created by 朱正晶 on 16/5/25.
//  Copyright © 2016年 omg. All rights reserved.
//

#import "KMCommonAlertView.h"

#define kBottomButtonHeight 50


@interface KMCommonAlertView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) UIView *customerView;

@property (nonatomic, strong) NSArray *realButtons;

@end

@implementation KMCommonAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    
    return self;
}

- (void)configView {
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0.36 green:0.79 blue:0.96 alpha:1.00];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@kBottomButtonHeight);
    }];
}

/**
 *  设置按钮
 *
 *  @param buttonsArray 按钮标题数组，只支持设置一个或者两个按钮
 */
- (void)setButtonsArray:(NSArray *)buttonsArray {
    if (buttonsArray.count != 1 && buttonsArray.count != 2) {
        return;
    }

    for (UIButton *button in self.realButtons) {
        [button removeFromSuperview];
    }
    
    _buttonsArray = buttonsArray;
    
    if (buttonsArray.count == 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.grayColor.CGColor;
        [button setTitle:buttonsArray[0] forState:UIControlStateNormal];
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        [button setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]] forState:UIControlStateHighlighted];
//        [button ]
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(1);
            make.height.equalTo(@kBottomButtonHeight);
        }];
        self.realButtons = @[button];
    } else if (buttonsArray.count == 2) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]] forState:UIControlStateHighlighted];
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.grayColor.CGColor;
        [button setTitle:buttonsArray[0] forState:UIControlStateNormal];
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_centerX).offset(0.5);
            make.bottom.equalTo(self).offset(1);
            make.height.equalTo(@kBottomButtonHeight);
        }];
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]] forState:UIControlStateHighlighted];
        button2.layer.borderWidth = 1;
        button2.layer.borderColor = UIColor.grayColor.CGColor;
        [button2 setTitle:buttonsArray[1] forState:UIControlStateNormal];
        [button2 setTitleColor:kMainColor forState:UIControlStateNormal];
        [self addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self.mas_centerX).offset(-0.5);
            make.bottom.equalTo(self).offset(1);
            make.height.equalTo(@kBottomButtonHeight);
        }];
        self.realButtons = @[button, button2];
    }
}

- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        _msgLabel = [UILabel new];
        _msgLabel.numberOfLines = 0;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_msgLabel];
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self).insets(UIEdgeInsetsMake(kBottomButtonHeight,
                                                                             0,
                                                                             kBottomButtonHeight,
                                                                             0));
        }];
    }
    
    return _msgLabel;
}

- (UIView *)customerView {
    if (_customerView == nil) {
        _customerView = [UIView new];
        [self addSubview:_customerView];
        [_customerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(kBottomButtonHeight, 0, kBottomButtonHeight, 0));
        }];
    }
    
    return _customerView;
}
#pragma mark --- 颜色生成图片
- (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0,30,30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
