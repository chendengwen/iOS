//
//  KMCountingLabel.h
//  YiYangCloud
//
//  Created by gary on 2017/4/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KMLabelCountingMethod) {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear
};

typedef NSString* (^UICountingLabelFormatBlock)(CGFloat value);
typedef NSAttributedString* (^UICountingLabelAttributedFormatBlock)(CGFloat value);

@interface KMCountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *positiveFormat;//如果浮点数需要千分位分隔符,须使用@"###,##0.00"进行控制样式

@property (nonatomic, assign) KMLabelCountingMethod method;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, copy) UICountingLabelFormatBlock formatBlock;
@property (nonatomic, copy) UICountingLabelAttributedFormatBlock attributedFormatBlock;
@property (nonatomic, copy) void (^completionBlock)();

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue;
-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromCurrentValueTo:(CGFloat)endValue;
-(void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromZeroTo:(CGFloat)endValue;
-(void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

@end



/**
 
 UICountingLabel *myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label3.frame) +20, WIDTH, 45)];
 myLabel.textAlignment = NSTextAlignmentCenter;
 myLabel.font = [UIFont fontWithName:@"Avenir Next" size:48];
 myLabel.textColor = [UIColor colorWithRed:236/255.0 green:66/255.0 blue:43/255.0 alpha:1];
 [self.view addSubview:myLabel];
 //设置格式
 myLabel.format = @"%.2f";
 //设置分隔符样式
 myLabel.floatingPositiveFormat = @"###,##0.00";
 //设置变化范围及动画时间
 [myLabel countFrom:0.00 to:3048.64   withDuration:2.0f];
 
 */
