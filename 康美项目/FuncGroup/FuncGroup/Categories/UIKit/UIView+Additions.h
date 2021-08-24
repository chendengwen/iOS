//
//  UIView+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIViewAutoresizingFlexibleMargins
#define UIViewAutoresizingFlexibleMargins UIViewAutoresizingFlexibleLeftMargin \
| UIViewAutoresizingFlexibleRightMargin \
| UIViewAutoresizingFlexibleTopMargin \
| UIViewAutoresizingFlexibleBottomMargin
#endif

#ifndef UIViewAutoresizingFlexibleSize
#define UIViewAutoresizingFlexibleSize UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
#endif


/**
 两个view排列方式
 */
typedef enum
{
    DDGUIViewArrangementDirectionNoChange,
    DDGUIViewArrangementDirectionAbove,      //当前view的上方
    DDGUIViewArrangementDirectionBelow,
    DDGUIViewArrangementDirectionLeft,
    DDGUIViewArrangementDirectionRight,
    DDGUIViewArrangementDirectionCenter
}  DDGUIViewArrangementDirection;


/**
 两个view排列对齐方式
 */
typedef enum
{
    DDGUIViewAlignmentNoChange,
    DDGUIViewAlignmentLeft,
    DDGUIViewAlignmentRight,
    DDGUIViewAlignmentCenter,
    DDGUIViewAlignmentTop,           //居顶/底对齐用于左右排列view
    DDGUIViewAlignmentBottom
} DDGUIViewAlignment;


@interface UIView (Additions)

/*!
 @brief UIView快速设置和获取
 */
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;


@property (nonatomic, weak) UIColor *borderColor;
/*!
 @brief 返回内部center
 */
@property (nonatomic, readonly, assign) CGPoint innerCenter;


/*!
 @property  UIViewController viewController
 @brief     当前view所在的viewController, 向上遍历, 没有则返回nil
 */
@property (nonatomic, readonly) UIViewController *viewController;

/*!
 @property  UIImage presentationImage
 @brief     当前view转换的UIImage对象
 */
@property (nonatomic, readonly) UIImage *presentationImage;


/*!
 @brief     移除该view下所有subview
 */
- (void)removeAllSubviews;

/*!
 @brief 移除视图上面的所有手势
 */
- (void)removeAllGestureRecognizer;


/*!
 @brief     设置当前view在父窗口中居中
 */
- (void)centerInSuperview;
/*!
 @brief     调换两个view的层级, 针对exchangeSubviewAtIndex:withSubviewAtIndex:的扩展
 @param     view1 调换层级的view
 @param     view2 调换层级的view
 */
- (void)exchangeSubview:(UIView *)view1 withSubview:(UIView *)view2;

/*!
 @brief     根据给定view来设置当前view的位置
 @param     view 指定作为基准的view
 @param     arrangement 排列方式，当前view居于给定view的上/下/左/右方，
 中间时alignment,padding无效，左右时alignment的上中下有效，上下时alignment左中右有效
 @param     alignment 对齐方式
 @param     padding 间隔距离
 */
- (void)layoutWithView:(UIView *)view
           arrangement:(DDGUIViewArrangementDirection)arrangement
             alignment:(DDGUIViewAlignment)alignment
               padding:(CGFloat)padding;
- (void)layoutWithView:(UIView *)view
           arrangement:(DDGUIViewArrangementDirection)arrangement
               padding:(CGFloat)padding;
- (void)layoutWithView:(UIView *)view
           arrangement:(DDGUIViewArrangementDirection)arrangement
             alignment:(DDGUIViewAlignment)alignment;


/*!
 @brief     当前view相对于顶层view的frame
 */
- (CGRect)viewRectToParentViewController;



@end
