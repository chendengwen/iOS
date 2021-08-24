//
//  UIView+DDGExtras.m
//  ddgBank
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 com.ddg. All rights reserved.
//

#import "UIView+DDGExtras.h"
#import <objc/runtime.h>

static NSString * const DDGExtrasViewNeedLineTopKey = @"DDGExtrasViewNeedLineTopKey";
static NSString * const DDGExtrasViewNeedLineLeftKey = @"DDGExtrasViewNeedLineLeftKey";
static NSString * const DDGExtrasViewNeedLineBottonKey = @"DDGExtrasViewNeedLineBottonKey";
static NSString * const DDGExtrasViewNeedLineRightKey = @"DDGExtrasViewNeedLineRightKey";
static NSString * const DDGExtrasViewLineWidthKey = @"DDGExtrasViewLineWidthKey";
static NSString * const DDGExtrasViewLineColorKey = @"DDGExtrasViewLineColorKey";

static NSString * const DDGExtrasViewRadiusTopRightKey = @"DDGExtrasViewRadiusTopRightKey";
static NSString * const DDGExtrasViewRadiusTopLeftKey = @"DDGExtrasViewRadiusTopLeftKey";
static NSString * const DDGExtrasViewRadiusBottonLeftKey = @"DDGExtrasViewRadiusBottonLeftKey";
static NSString * const DDGExtrasViewRadiusBottomRightKey = @"DDGExtrasViewRadiusBottomRightKey";

static NSString * const DDGExtrasViewFillColorKey = @"DDGExtrasViewFillColorKey";

static NSString * const DDGExtrasViewClipsToBoundsWithBorderKey = @"DDGExtrasViewClipsToBoundsWithBorderKey";


@interface UIView ()
@property (retain,nonatomic) UIBezierPath *pathForBorder;
@property (assign,nonatomic) BOOL needUpdatePathForBorder;
@end

@implementation UIView (DDGExtras)

#pragma mark - Setters
- (void)setNeedLineTop:(BOOL)needLineTop {
    objc_setAssociatedObject(self, &DDGExtrasViewNeedLineTopKey, [NSNumber numberWithBool:needLineTop], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (BOOL)needLineTop {
    return [objc_getAssociatedObject(self, &DDGExtrasViewNeedLineTopKey) boolValue];
}

- (void)setNeedLineLeft:(BOOL)needLineLeft {
    objc_setAssociatedObject(self, &DDGExtrasViewNeedLineLeftKey, [NSNumber numberWithBool:needLineLeft], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (BOOL)needLineLeft {
    return [objc_getAssociatedObject(self, &DDGExtrasViewNeedLineLeftKey) boolValue];
}

- (void)setNeedLineBottom:(BOOL)needLineBottom {
    objc_setAssociatedObject(self, &DDGExtrasViewNeedLineBottonKey, [NSNumber numberWithBool:needLineBottom], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (BOOL)needLineBottom {
    return [objc_getAssociatedObject(self, &DDGExtrasViewNeedLineBottonKey) boolValue];
}

- (void)setNeedLineRight:(BOOL)needLineRight{
    objc_setAssociatedObject(self, &DDGExtrasViewNeedLineRightKey, [NSNumber numberWithBool:needLineRight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (BOOL)needLineRight {
    return [objc_getAssociatedObject(self, &DDGExtrasViewNeedLineRightKey) boolValue];
}

- (void)setLineWidth:(CGFloat)lineWidth{
    objc_setAssociatedObject(self, &DDGExtrasViewLineWidthKey, [NSNumber numberWithFloat:lineWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (CGFloat)lineWidth {
    return [objc_getAssociatedObject(self, &DDGExtrasViewLineWidthKey) floatValue];
}

- (void)setLineColor:(UIColor *)lineColor{
    objc_setAssociatedObject(self, &DDGExtrasViewLineColorKey, lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (UIColor *)lineColor {
    return objc_getAssociatedObject(self, &DDGExtrasViewLineColorKey);
}

- (void)setFillColor:(UIColor *)fillColor{
    objc_setAssociatedObject(self, &DDGExtrasViewFillColorKey, fillColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (UIColor *)fillColor {
    return objc_getAssociatedObject(self, &DDGExtrasViewFillColorKey);
}

- (void)setRadiusTopLeft:(CGFloat)radiusTopLeft{
    objc_setAssociatedObject(self, &DDGExtrasViewRadiusTopLeftKey, [NSNumber numberWithFloat:radiusTopLeft], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (CGFloat)radiusTopLeft {
    return [objc_getAssociatedObject(self, &DDGExtrasViewRadiusTopLeftKey) floatValue];
}

- (void)setRadiusTopRight:(CGFloat)radiusTopRight{
    objc_setAssociatedObject(self, &DDGExtrasViewRadiusTopRightKey, [NSNumber numberWithFloat:radiusTopRight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (CGFloat)radiusTopRight {
    return [objc_getAssociatedObject(self, &DDGExtrasViewRadiusTopRightKey) floatValue];
}

- (void)setRadiusBottomRight:(CGFloat)radiusBottomRight{
    objc_setAssociatedObject(self, &DDGExtrasViewRadiusBottomRightKey, [NSNumber numberWithFloat:radiusBottomRight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (CGFloat)radiusBottomRight {
    return [objc_getAssociatedObject(self, &DDGExtrasViewRadiusBottomRightKey) floatValue];
}

- (void)setRadiusBottomLeft:(CGFloat)radiusBottomLeft{
    objc_setAssociatedObject(self, &DDGExtrasViewRadiusBottonLeftKey, [NSNumber numberWithFloat:radiusBottomLeft], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.needUpdatePathForBorder=true;
}
- (CGFloat)radiusBottomLeft {
    return [objc_getAssociatedObject(self, &DDGExtrasViewRadiusBottonLeftKey) floatValue];
    
}

- (void)setClipsToBoundsWithBorder:(BOOL)clipsToBoundsWithBorder{
    objc_setAssociatedObject(self, &DDGExtrasViewClipsToBoundsWithBorderKey, [NSNumber numberWithBool:clipsToBoundsWithBorder], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)clipsToBoundsWithBorder {
    return [objc_getAssociatedObject(self, &DDGExtrasViewClipsToBoundsWithBorderKey) boolValue];
}



#pragma mark === PublichMethod
-(void)setNeedLineTop:(BOOL)needTop left:(BOOL)needLeft bottom:(BOOL)needBottom right:(BOOL)needRight{
    self.needLineTop=needTop;
    self.needLineLeft=needLeft;
    self.needLineRight=needRight;
    self.needLineBottom=needBottom;
}

-(void)setRadiusTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight{
    self.radiusTopLeft=topLeft;
    self.radiusTopRight=topRight;
    self.radiusBottomLeft=bottomLeft;
    self.radiusBottomRight=bottomRight;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    if ([self clipsToBoundsWithBorder]) {
        UIBezierPath *bezierPath=[self bezierPathForBorder];
        CAShapeLayer* maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.bounds;
        maskLayer.path = bezierPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

//-(void)setFrame:(CGRect)frame{
//    if (!CGRectEqualToRect(self.frame, frame)) {
//        self.needUpdatePathForBorder=true;
//    }
//    self.frame = frame;
//}







//- (void)drawRect:(CGRect)rect
//{
//    CGFloat halfLineWidthTop=self.lineWidth/2;
//    CGFloat halfLineWidthLeft=self.lineWidth/2;
//    CGFloat halfLineWidthBottom=self.lineWidth/2;
//    CGFloat halfLineWidthRight=self.lineWidth/2;
//    
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextClearRect(context, self.bounds);
//    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
//    CGContextFillRect(context, self.bounds);
//    
//    //填充背景
//    if (self.fillColor) {
//        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
//        UIBezierPath *bezierPath=[self bezierPathForBorder];
//        [bezierPath fill];
//    }
//    //画线
//    if (self.needLineTop) {
//        CGContextSetLineWidth(context, self.lineWidth);
//        CGContextSetStrokeColorWithColor(context, (self.lineColor?self.lineColor:[UIColor blackColor]).CGColor);
//        CGContextAddArc(context, self.frame.size.width-self.radiusTopRight, self.radiusTopRight, self.radiusTopRight-halfLineWidthTop, -M_PI_4+(self.needLineRight?0:M_PI_4), -M_PI_2, 1);
//        CGContextMoveToPoint(context, self.frame.size.width-self.radiusTopRight, halfLineWidthTop);
//        CGContextAddLineToPoint(context, self.radiusTopLeft, halfLineWidthTop);
//        CGContextAddArc(context, self.radiusTopLeft, self.radiusTopLeft, self.radiusTopLeft - halfLineWidthTop, -M_PI_2, -M_PI_2-M_PI_4-(self.needLineLeft?0:M_PI_4), 1);
//        CGContextStrokePath(context);
//    }
//    if (self.needLineLeft) {
//        CGContextSetLineWidth(context, self.lineWidth);
//        CGContextSetStrokeColorWithColor(context, (self.lineColor?self.lineColor:[UIColor blackColor]).CGColor);
//        CGContextAddArc(context, self.radiusTopLeft, self.radiusTopLeft, self.radiusTopLeft - halfLineWidthLeft, -M_PI, -M_PI_2-M_PI_4+(self.needLineTop?0:M_PI_4), 0);
//        CGContextMoveToPoint(context, halfLineWidthLeft, self.radiusTopLeft);
//        CGContextAddLineToPoint(context, halfLineWidthLeft, self.frame.size.height - self.radiusBottomLeft);
//        CGContextAddArc(context, self.radiusBottomLeft, self.frame.size.height - self.radiusBottomLeft, self.radiusBottomLeft-halfLineWidthLeft, M_PI, M_PI-M_PI_4-(self.needLineBottom?0:M_PI_4), 1);
//        CGContextStrokePath(context);
//    }
//    if (self.needLineBottom) {
//        CGContextSetLineWidth(context, self.lineWidth);
//        CGContextSetStrokeColorWithColor(context, (self.lineColor?self.lineColor:[UIColor blackColor]).CGColor);
//        CGContextAddArc(context, self.radiusBottomLeft, self.frame.size.height - self.radiusBottomLeft, self.radiusBottomLeft-halfLineWidthBottom, M_PI-M_PI_4+(self.needLineLeft?0:M_PI_4), M_PI_2, 1);
//        CGContextMoveToPoint(context, self.radiusBottomLeft, self.frame.size.height - halfLineWidthBottom);
//        CGContextAddLineToPoint(context, self.frame.size.width - self.radiusBottomRight, self.frame.size.height-halfLineWidthBottom);
//        CGContextAddArc(context, self.frame.size.width-self.radiusBottomRight, self.frame.size.height-self.radiusBottomRight, self.radiusBottomRight-halfLineWidthBottom, M_PI_2, M_PI_4-(self.needLineRight?0:M_PI_4), 1);
//        CGContextStrokePath(context);
//    }
//    if (self.needLineRight) {
//        CGContextSetLineWidth(context, self.lineWidth);
//        CGContextSetStrokeColorWithColor(context, (self.lineColor?self.lineColor:[UIColor blackColor]).CGColor);
//        CGContextAddArc(context, self.frame.size.width-self.radiusBottomRight, self.frame.size.height-self.radiusBottomRight, self.radiusBottomRight - halfLineWidthRight, M_PI_4+(self.needLineBottom?0:M_PI_4), 0, 1);
//        CGContextMoveToPoint(context, self.frame.size.width - halfLineWidthRight, self.frame.size.height-self.radiusBottomRight);
//        CGContextAddLineToPoint(context, self.frame.size.width - halfLineWidthRight, self.radiusTopRight);
//        CGContextAddArc(context, self.frame.size.width-self.radiusTopRight, self.radiusTopRight, self.radiusTopRight-halfLineWidthRight, 0, -M_PI_4-(self.needLineTop?0:M_PI_4), 1);
//        CGContextStrokePath(context);
//    }
//    CGContextStrokePath(context);
//}


-(UIBezierPath*)bezierPathForBorder{
    
    if (self.needUpdatePathForBorder || !self.pathForBorder) {
        CGFloat halfLineWidth = self.lineWidth/2;
        UIBezierPath *bezierPath=[UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(self.frame.size.width - self.radiusTopRight, 0)];
        [bezierPath addLineToPoint:CGPointMake(self.radiusTopLeft, 0)];
        [bezierPath addQuadCurveToPoint:CGPointMake(0, self.radiusTopLeft) controlPoint:CGPointMake(halfLineWidth, halfLineWidth)];
        [bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height - self.radiusBottomLeft)];
        [bezierPath addQuadCurveToPoint:CGPointMake(self.radiusBottomLeft, self.frame.size.height) controlPoint:CGPointMake(halfLineWidth, self.frame.size.height - halfLineWidth)];
        [bezierPath moveToPoint:CGPointMake(self.radiusBottomLeft, self.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width-self.radiusBottomRight, self.frame.size.height)];
        [bezierPath addQuadCurveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-self.radiusBottomRight) controlPoint:CGPointMake(self.frame.size.width - halfLineWidth, self.frame.size.height-halfLineWidth)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.radiusTopRight)];
        [bezierPath addQuadCurveToPoint:CGPointMake(self.frame.size.width - self.radiusTopRight, 0) controlPoint:CGPointMake(self.frame.size.width-halfLineWidth, halfLineWidth)];
        self.pathForBorder=bezierPath;
        self.needUpdatePathForBorder=false;
    }
    return self.pathForBorder;
}

@end
