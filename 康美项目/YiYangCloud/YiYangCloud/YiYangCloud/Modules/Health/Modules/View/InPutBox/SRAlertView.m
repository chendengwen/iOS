//
//  SRAlertView.m
//  SRAlertViewDemo
//
//  Created by 郭伟林 on 16/7/8.
//  Copyright © 2016年 SR. All rights reserved.
//

#define SCREEN_BOUNDS          [UIScreen mainScreen].bounds
#define SCREEN_ADJUST(Value)   SCREEN_WIDTH * (Value) / 375.0f

#define COLOR_RGB(R, G, B)              [UIColor colorWithRed:(R/255.0f) green:(G/255.0f) blue:(B/255.0f) alpha:1.0f]
#define COLOR_RANDOM                    COLOR_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kTitleLabelColor                [UIColor blackColor]
#define kMessageLabelColor              [UIColor grayColor]
#define kLineBackgroundColor            [UIColor colorWithHexString:@"#dcdcdc"]

#define kBtnNormalTitleColor            [UIColor colorWithHexString:@"#507af8"]
#define kBtnHighlightedTitleColor       [UIColor whiteColor]
#define kBtnHighlightedBackgroundColor  [UIColor grayColor]

#define kAlertViewW             275.0f
#define kAlertViewTitleH        20.0f
#define kAlertViewBtnH          50.0f
#define kAlertViewMessageMinH   75.0f

#define kTitleFont      [UIFont boldSystemFontOfSize:SCREEN_ADJUST(18)];
#define kMessageFont    [UIFont systemFontOfSize:SCREEN_ADJUST(15)];
#define kBtnTitleFont   [UIFont systemFontOfSize:SCREEN_ADJUST(16)];

#import "SRAlertView.h"
#import "UIColor+YYAdd.h"
#import "UIView+YYAdd.h"

@interface SRAlertView()

@property (nonatomic, weak  ) id<SRAlertViewDelegate>   delegate;

@property (nonatomic, copy  ) AlertViewDidClickBtnBlock clickBtnBlock;

@property (nonatomic, assign) AlertViewAnimationStyle   animationStyle;

@property (nonatomic, strong) UIView   *alertView;
@property (nonatomic, strong) UIView   *coverView;

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, copy  ) NSString *message;
@property (nonatomic, strong) UILabel  *messageLabel;

@property (nonatomic, copy  ) NSString *leftBtnTitle;
@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, copy  ) NSString *rightBtnTitle;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, assign) BOOL isTis;

@end

@implementation SRAlertView

#pragma mark - BLOCK

+ (void)sr_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
                   animationStyle:(AlertViewAnimationStyle)animationStyle
                    clickBtnBlock:(AlertViewDidClickBtnBlock)clickBtnBlock
{
    SRAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                            leftBtnTitle:leftBtnTitle
                                           rightBtnTitle:rightBtnTitle
                                          animationStyle:animationStyle
                                           clickBtnBlock:clickBtnBlock];
    [alertView show];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 leftBtnTitle:(NSString *)leftBtnTitle
                rightBtnTitle:(NSString *)rightBtnTitle
               animationStyle:(AlertViewAnimationStyle)animationStyle
                clickBtnBlock:(AlertViewDidClickBtnBlock)clickBtnBlock
{
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        //self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _title          = title;
        _message        = message;
        _leftBtnTitle   = leftBtnTitle;
        _rightBtnTitle  = rightBtnTitle;
        _animationStyle = animationStyle;
        _clickBtnBlock  = clickBtnBlock;
        [self setupCoverView];
        [self setupAlertView];
    }
    return self;
}

#pragma mark - DELEGATE

+ (void)sr_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
                   animationStyle:(AlertViewAnimationStyle)animationStyle
                         delegate:(id<SRAlertViewDelegate>)delegate
{
    SRAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                            leftBtnTitle:leftBtnTitle
                                           rightBtnTitle:rightBtnTitle
                                          animationStyle:animationStyle
                                                delegate:delegate
                                                     Tis:NO];
    [alertView show];
}

+ (void)sr_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
                   animationStyle:(AlertViewAnimationStyle)animationStyle
                         delegate:(id<SRAlertViewDelegate>)delegate
                              Tis:(BOOL)isTis
{
    SRAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                            leftBtnTitle:leftBtnTitle
                                           rightBtnTitle:rightBtnTitle
                                          animationStyle:animationStyle
                                                delegate:delegate
                                                     Tis:isTis];
    
    [alertView show];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 leftBtnTitle:(NSString *)leftBtnTitle
                rightBtnTitle:(NSString *)rightBtnTitle
               animationStyle:(AlertViewAnimationStyle)animationStyle
                     delegate:(id<SRAlertViewDelegate>)delegate
                          Tis:(BOOL)isTis
{
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        _title          = title;
        _message        = message;
        _leftBtnTitle   = leftBtnTitle;
        _rightBtnTitle  = rightBtnTitle;
        _animationStyle = animationStyle;
        _delegate       = delegate;
        _isTis          = isTis;
        [self setupCoverView];
        [self setupAlertView];
    }
    return self;
}

#pragma mark - Setup

- (void)setupCoverView {
    
    [self addSubview:({
        self.coverView = [[UIView alloc] initWithFrame:self.bounds];
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.coverView.alpha = 0;
        self.coverView;
    })];
}

- (void)setupAlertView {
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    CGFloat verticalMargin = 20;
    if (_title) {
        [_alertView addSubview:({
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, verticalMargin, kAlertViewW, kAlertViewTitleH)];
            _titleLabel.text          = _title;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor     = [UIColor blackColor];
            _titleLabel.font          = kTitleFont;
            _titleLabel;
        })];
    }
    
    CGFloat messageLabelSpacing = 20;
    [_alertView addSubview:({
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.textColor       = [UIColor lightGrayColor];
        _messageLabel.font            = kMessageFont;
        _messageLabel.numberOfLines   = 0;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maxSize = CGSizeMake(kAlertViewW - messageLabelSpacing * 2, MAXFLOAT);
        _messageLabel.text = @"one";
        CGSize tempSize    = [_messageLabel sizeThatFits:maxSize];
        _messageLabel.text = _message;
        CGSize expectSize  = [_messageLabel sizeThatFits:maxSize];
        if (expectSize.height == tempSize.height) {
            // if just only one line then set textAlignment is NSTextAlignmentCenter.
            _messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        [_messageLabel sizeToFit];
        CGFloat messageLabH = expectSize.height < kAlertViewMessageMinH ? kAlertViewMessageMinH : expectSize.height;
        _messageLabel.frame = CGRectMake(messageLabelSpacing, CGRectGetMaxY(_titleLabel.frame) + verticalMargin,
                                         kAlertViewW - messageLabelSpacing * 2, messageLabH);
        _messageLabel;
    })];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertViewW, CGRectGetMaxY(_messageLabel.frame) + kAlertViewBtnH + verticalMargin);
    _alertView.center = self.center;
    
    CGFloat btnY = _alertView.frame.size.height - kAlertViewBtnH;
    if (_leftBtnTitle) {
        [_alertView addSubview:({
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn.tag = AlertViewBtnTypeLeft;
            _leftBtn.titleLabel.font = kBtnTitleFont;
            [_leftBtn setTitle:_leftBtnTitle forState:UIControlStateNormal];
            [_leftBtn setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_leftBtn setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            [_leftBtn setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_leftBtn];
            if (_rightBtnTitle) {
                _leftBtn.frame = CGRectMake(0, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _leftBtn.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _leftBtn;
        })];
    }
    
    if (_rightBtnTitle) {
        [_alertView addSubview:({
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn.tag = AlertViewBtnTypeRight;
            _rightBtn.titleLabel.font = kBtnTitleFont;
            [_rightBtn setTitle:_rightBtnTitle forState:UIControlStateNormal];
            [_rightBtn setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_rightBtn setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            [_rightBtn setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_rightBtn];
            if (_leftBtnTitle) {
                _rightBtn.frame = CGRectMake(kAlertViewW * 0.5, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _rightBtn.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _rightBtn;
        })];
    }
    
    if (_leftBtnTitle && _rightBtnTitle) {
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(0, btnY, kAlertViewW, 1);
        line1.backgroundColor = kLineBackgroundColor;
        [_alertView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] init];
        line2.frame = CGRectMake(kAlertViewW * 0.5, btnY, 1, kAlertViewBtnH);
        line2.backgroundColor = kLineBackgroundColor;
        [_alertView addSubview:line2];
    } else {
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, btnY, kAlertViewW, 1);
        line.backgroundColor = kLineBackgroundColor;
        [_alertView addSubview:line];
    }
    
    if (self.isTis) {
        
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 85, 16)];
        selectBtn.centerX = _titleLabel.centerX;
        selectBtn.centerY = _alertView.height * 0.5 + 30;
        selectBtn.titleLabel.font = kMessageFont;
        selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [selectBtn setTitleColor:kMessageLabelColor forState:UIControlStateNormal];
        [selectBtn setTitle:@"不再提醒" forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:selectBtn];
    }

}

#pragma mark - Actions
//不再提醒
- (void)didClickBtn:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:@"isNoReminder"];
}

- (void)btnAction:(UIButton *)btn {
    
    if (self.clickBtnBlock) {
        self.clickBtnBlock(btn.tag);
    }
    if ([self.delegate respondsToSelector:@selector(alertViewDidClickBtn:)]) {
        [self.delegate alertViewDidClickBtn:btn.tag];
    }
    
    [self dismiss];
}

#pragma mark - Animations

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.coverView.alpha = 1.0;
                     } completion:nil];

    switch (self.animationStyle) {
        case AlertViewAnimationNone:
        {
            // No animation
            break;
        }
        case AlertViewAnimationZoom:
        {
            [self.alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.alertView.layer setValue:@(1.1) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.alertView.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self.alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                    } completion:nil];
                }];
            }];
            break;
        }
        case AlertViewAnimationTopToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, -self.alertView.frame.size.height);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case AlertViewAnimationDownToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, SCREEN_HEIGHT);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case AlertViewAnimationLeftToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(-kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case AlertViewAnimationRightToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(SCREEN_WIDTH + kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
    }
}

- (void)dismiss {

    [self.alertView removeFromSuperview];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.coverView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Other

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Public interface

- (void)setButtonWhenHighlightedBackgroundColor:(UIColor *)buttonWhenHighlightedBackgroundColor {
    
    _buttonWhenHighlightedBackgroundColor = buttonWhenHighlightedBackgroundColor;
    
    [self.leftBtn  setBackgroundImage:[self imageWithColor:buttonWhenHighlightedBackgroundColor] forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:[self imageWithColor:buttonWhenHighlightedBackgroundColor] forState:UIControlStateHighlighted];
}

- (void)setButtonWhenHighlightedTitleColor:(UIColor *)buttonWhenHighlightedTitleColor {
    
    _buttonWhenHighlightedTitleColor = buttonWhenHighlightedTitleColor;
    
    [self.leftBtn  setTitleColor:buttonWhenHighlightedTitleColor forState:UIControlStateHighlighted];
    [self.rightBtn setTitleColor:buttonWhenHighlightedTitleColor forState:UIControlStateHighlighted];
}

@end
