//
//  UIView+Additions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Additions.h"
#import "Frame+Additions.h"
#import <objc/runtime.h>


static NSString * const DDGExtrasViewBorderColor = @"DDGExtrasViewBorderColor";

@implementation UIView (Additions)

- (void)setSize:(CGSize)size;
{
    CGPoint origin = self.frame.origin;
    
    self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (CGSize)size;
{
    return self.frame.size;
}

- (CGFloat)left;
{
    return CGRectGetMinX(self.frame);
}

- (void)setLeft:(CGFloat)x;
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top;
{
    return CGRectGetMinY(self.frame);
}

- (void)setTop:(CGFloat)y;
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right;
{
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right;
{
    CGRect frame = self.frame;
    frame.origin.x = right - CGRectGetWidth(frame);
    
    self.frame = frame;
}

- (CGFloat)bottom;
{
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom;
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - CGRectGetHeight(frame);
    
    self.frame = frame;
}

- (CGFloat)centerX;
{
    return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX;
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY;
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY;
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width;
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width;
{
    CGRect frame = self.frame;
    frame.size.width = width;
    
    self.frame = CGRectStandardize(frame);
}

- (CGFloat)height;
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height;
{
    CGRect frame = self.frame;
    frame.size.height = height;
    
    self.frame = CGRectStandardize(frame);
}

-(UIColor *)borderColor{
    return [UIColor redColor];
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}


- (CGPoint)innerCenter
{
    return CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
}

- (UIViewController *)viewController
{
    for (UIView *view = self; view; view = view.superview)
        if ([view.nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController *)view.nextResponder;
    
    return nil;
}

- (UIImage *)presentationImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
        [(UIView *)self.subviews.lastObject removeFromSuperview];
}

- (void)removeAllGestureRecognizer
{
    while (self.gestureRecognizers.count)
        [self removeGestureRecognizer:self.gestureRecognizers.lastObject];
}



- (void)centerInSuperview
{
    if (self.superview)
        self.center = CGRectGetCenter(self.superview.bounds);
}

- (void)exchangeSubview:(UIView *)view1 withSubview:(UIView *)view2
{
    NSUInteger index1 = [self.subviews indexOfObject:view1];
    if (index1 == NSNotFound) return;
    NSUInteger index2 = [self.subviews indexOfObject:view2];
    if (index2 == NSNotFound) return;
    
    [self exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
}

- (void)layoutWithView:(UIView *)view
           arrangement:(DDGUIViewArrangementDirection)arrangement
             alignment:(DDGUIViewAlignment)alignment
               padding:(CGFloat)padding
{
    //排列居中时设置center值
    if (arrangement == DDGUIViewArrangementDirectionCenter)
    {
        self.center = view.center;
        return;
    }
    
    CGRect rect1 = self.frame;
    CGRect rect2 = view.frame;
    switch (arrangement)
    {
        case DDGUIViewArrangementDirectionAbove:
            rect1.origin.y = CGRectGetMinY(rect2) - padding - CGRectGetHeight(rect1);
            break;
        case DDGUIViewArrangementDirectionBelow:
            rect1.origin.y = CGRectGetMaxY(rect2) + padding;
            break;
        case DDGUIViewArrangementDirectionLeft:
            rect1.origin.x = CGRectGetMinX(rect2) - padding - CGRectGetWidth(rect1);
            break;
        case DDGUIViewArrangementDirectionRight:
            rect1.origin.x = CGRectGetMaxX(rect2) + padding;
        default:
            break;
    }
    switch (alignment)
    {
        case DDGUIViewAlignmentTop:
            if (arrangement == DDGUIViewArrangementDirectionLeft || arrangement == DDGUIViewArrangementDirectionRight)
                rect1.origin.y = rect2.origin.y;
            break;
        case DDGUIViewAlignmentBottom:
            if (arrangement == DDGUIViewArrangementDirectionLeft || arrangement == DDGUIViewArrangementDirectionRight)
                rect1.origin.y = CGRectGetMaxY(rect2) - CGRectGetHeight(rect1);
            break;
        case DDGUIViewAlignmentLeft:
            if (arrangement == DDGUIViewArrangementDirectionAbove || arrangement == DDGUIViewArrangementDirectionBelow)
                rect1.origin.x = rect2.origin.x;
            break;
        case DDGUIViewAlignmentRight:
            if (arrangement == DDGUIViewArrangementDirectionAbove || arrangement == DDGUIViewArrangementDirectionBelow)
                rect1.origin.x = CGRectGetMaxX(rect2) - CGRectGetWidth(rect1);
            break;
        case DDGUIViewAlignmentCenter:
            if (arrangement == DDGUIViewArrangementDirectionLeft || arrangement == DDGUIViewArrangementDirectionRight)
                rect1.origin.y = CGRectGetCenter(rect2).y - CGRectGetHeight(rect1)/2;
            else if (arrangement == DDGUIViewArrangementDirectionAbove ||
                     arrangement == DDGUIViewArrangementDirectionBelow)
                rect1.origin.x = CGRectGetCenter(rect2).x - CGRectGetWidth(rect1)/2;
            break;
        default:
            break;
    }
    
    self.frame = rect1;
}

- (void)layoutWithView:(UIView *)view
           arrangement:(DDGUIViewArrangementDirection)arrangement
               padding:(CGFloat)padding
{
    [self layoutWithView:view
             arrangement:arrangement
               alignment:DDGUIViewAlignmentNoChange
                 padding:padding];
}
- (void)layoutWithView:(UIView *)view
           arrangement:(DDGUIViewArrangementDirection)arrangement
             alignment:(DDGUIViewAlignment)alignment
{
    [self layoutWithView:view
             arrangement:arrangement
               alignment:alignment
                 padding:0];
}


- (CGRect)viewRectToParentViewController
{
    UIViewController *viewController = [self viewController];
    if (self.superview)
    {
        return [self.superview convertRect:self.frame toView:viewController.view];
    }
    
    return self.bounds;
}


@end
