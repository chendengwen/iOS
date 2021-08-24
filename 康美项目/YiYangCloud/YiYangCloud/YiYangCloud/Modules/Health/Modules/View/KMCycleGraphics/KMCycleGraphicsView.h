//
//  KMCycleGraphicsView.h
//  YiYangCloud
//
//  Created by gary on 2017/4/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMCycleGraphicsView : UIView

//@property (nonatomic,assign) CGFloat  duration;
-(void)reset;
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title valueFormat:(NSString *)format;
-(void)reloadGraphics:(UIColor *)color toValue:(CGFloat)value totalValue:(CGFloat)totalValue;
-(void)reloadGraphics:(UIColor *)color maxValue:(CGFloat)maxValue totalValue:(CGFloat)totalValue;
@end
