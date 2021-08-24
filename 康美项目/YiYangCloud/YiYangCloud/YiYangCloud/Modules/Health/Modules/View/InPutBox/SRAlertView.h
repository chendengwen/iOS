//
//  SRAlertView.h
//  SRAlertViewDemo
//
//  Created by 郭伟林 on 16/7/8.
//  Copyright © 2016年 SR. All rights reserved.
//

/**
 *  If you have any question, please issue or contact me.
 *  QQ: 396658379
 *  Email: guowilling@qq.com
 *
 *  If you like it, please star it, thanks a lot.
 *  Github: https://github.com/guowilling/SRAlertView
 *
 *  Have Fun.
 */

#import <UIKit/UIKit.h>

@class SRAlertView;

typedef NS_ENUM(NSInteger, AlertViewBtnType) {
    AlertViewBtnTypeLeft,
    AlertViewBtnTypeRight,
};

typedef NS_ENUM(NSInteger, AlertViewAnimationStyle) {
    AlertViewAnimationNone,
    AlertViewAnimationZoom,
    AlertViewAnimationTopToCenterSpring,
    AlertViewAnimationDownToCenterSpring,
    AlertViewAnimationLeftToCenterSpring,
    AlertViewAnimationRightToCenterSpring,
};

@protocol SRAlertViewDelegate <NSObject>

@required
- (void)alertViewDidClickBtn:(AlertViewBtnType)btnType;

@end

typedef void(^AlertViewDidClickBtnBlock)(AlertViewBtnType btnType);

@interface SRAlertView : UIView

/**
 Button's background color when highlighted, default is [UIColor orangeColor].
 */
@property (nonatomic, strong) UIColor *buttonWhenHighlightedBackgroundColor;

/**
 Button's title color when highlighted, default is [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *buttonWhenHighlightedTitleColor;

#pragma mark - BLOCK

+ (void)sr_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
                   animationStyle:(AlertViewAnimationStyle)animationStyle
                    clickBtnBlock:(AlertViewDidClickBtnBlock)clickBtnBlock;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 leftBtnTitle:(NSString *)leftBtnTitle
                rightBtnTitle:(NSString *)rightBtnTitle
               animationStyle:(AlertViewAnimationStyle)animationStyle
                clickBtnBlock:(AlertViewDidClickBtnBlock)clickBtnBlock;

#pragma mark - DELEGATE

+ (void)sr_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
                   animationStyle:(AlertViewAnimationStyle)animationStyle
                         delegate:(id<SRAlertViewDelegate>)delegate;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 leftBtnTitle:(NSString *)leftBtnTitle
                rightBtnTitle:(NSString *)rightBtnTitle
               animationStyle:(AlertViewAnimationStyle)animationStyle

                     delegate:(id<SRAlertViewDelegate>)delegate;
+ (void)sr_showAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
                   animationStyle:(AlertViewAnimationStyle)animationStyle
                         delegate:(id<SRAlertViewDelegate>)delegate
                              Tis:(BOOL)isTis;
@end
