//
//  KMCycleGraphicsView.m
//  YiYangCloud
//
//  Created by gary on 2017/4/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "KMCycleGraphicsView.h"
#import "KMCountingLabel.h"

#define LINE_WIDTH 10//环形宽度
#define DURATION 1.0//动画时间
#define BG_COLOR UIColorFromRGB(0xf4f3f8)

@interface KMCycleGraphicsView ()

@property (nonatomic,assign) float      percent;
@property (nonatomic,assign) float      maxValue;
@property (nonatomic,assign) float      radius;
@property (nonatomic,assign) CGPoint    centerPoint;
@property (nonatomic,strong) UIColor    *mainColor;

@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CATextLayer  *textLayer;
@property (nonatomic,strong) CAShapeLayer *pointLayer;

@property (nonatomic,strong) KMCountingLabel *countingLabel;

@property (nonatomic,assign) IBInspectable CGFloat width;
@property (nonatomic,copy) IBInspectable NSString *title;
@property (nonatomic,copy) IBInspectable NSString *valueFormat;

@end

@implementation KMCycleGraphicsView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title valueFormat:(NSString *)format{
    self = [super initWithFrame:frame];
    if (self) {
        self.radius = CGRectGetWidth(frame)/2.0 - LINE_WIDTH/2.0;
        self.centerPoint = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetWidth(frame) / 2.0);
        self.title = title;
        self.valueFormat = format;
        [self defaultSetting];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    if (self.mainColor == nil && self.width > 0) {
        self.radius = self.width/2.0 - LINE_WIDTH/2.0;
        self.mainColor = UIColorFromRGB(0x7fc156);
        self.centerPoint = CGPointMake(self.width / 2.0, self.width / 2.0);
        
        [self defaultSetting];
    }
    
}

-(void)reloadGraphics:(UIColor *)color maxValue:(CGFloat)maxValue totalValue:(CGFloat)totalValue{
    self.maxValue = maxValue;
    [self reloadGraphics:color toValue:totalValue totalValue:totalValue];
}

-(void)reloadGraphics:(UIColor *)color toValue:(CGFloat)value totalValue:(CGFloat)totalValue{
    self.percent = value;
    self.mainColor = color;//UIColorFromRGB(0x7fc156)
    
    [self createPercentLayer];
    //设置变化范围及动画时间
    [_countingLabel countFrom:0.00 to:totalValue withDuration:DURATION];
}

-(void)defaultSetting{
    [self createBackLine];
    [self createTextLayer];
    [self createCountingLabel];
}

-(void)reset{
    [_countingLabel countFrom:0.00 to:0 withDuration:0.3];
    [self.lineLayer removeFromSuperlayer];
}

-(void)createBackLine {
    //绘制背景
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = LINE_WIDTH;
    shapeLayer.strokeColor = [BG_COLOR CGColor];
//    shapeLayer.opacity = 0.2;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath new];
    [path addArcWithCenter:self.centerPoint radius:self.radius startAngle:-M_PI / 2.0 endAngle:M_PI / 2 * 3 clockwise:YES];
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
}

-(void)createTextLayer{
    self.textLayer = [CATextLayer layer];
    self.textLayer.contentsScale = [[UIScreen mainScreen] scale];
    self.textLayer.string = self.title;
    self.textLayer.bounds = self.bounds;
    self.textLayer.font = (__bridge CFTypeRef _Nullable)(@"ArialHebrew");
    self.textLayer.fontSize = 12.0;
    self.textLayer.alignmentMode = kCAAlignmentCenter;
    self.textLayer.position = CGPointMake(self.centerPoint.x, self.centerPoint.y + self.radius + 30);
    self.textLayer.foregroundColor = [UIColor colorWithRed:96/255.0 green:105/255.0 blue:142/255.0 alpha:1].CGColor;
    [self.layer addSublayer:self.textLayer];
}

-(void)createCountingLabel{
    _countingLabel = [[KMCountingLabel alloc] initWithFrame:CGRectMake(0, 0, 180, 45)];
    _countingLabel.center = CGPointMake(self.centerPoint.x, self.centerPoint.y - 10);
    _countingLabel.textAlignment = NSTextAlignmentCenter;
    _countingLabel.font = [UIFont fontWithName:@"ArialMT" size:42];
    _countingLabel.textColor = [UIColor colorWithRed:80/255.0 green:122/255.0 blue:248/255.0 alpha:1];
    [self addSubview:_countingLabel];
    //设置格式
    _countingLabel.format = self.valueFormat;
//    if ([self.valueFormat isEqualToString:@"%.2f"]) {
//        _countingLabel.positiveFormat = @"###,#00.00";
//    }
}

-(void)createPercentLayer {
    //比例计算
    self.percent = self.percent > self.maxValue ? self.maxValue : self.percent;
    CGFloat move = (2 * M_PI / self.maxValue) * self.percent -  M_PI_2;
    //绘制环形
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.lineWidth = LINE_WIDTH;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.strokeColor = [self.mainColor CGColor];
    self.lineLayer.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath new];
    [path addArcWithCenter:self.centerPoint radius:self.radius startAngle:- M_PI_2 endAngle:move  clockwise:YES];
    self.lineLayer.path = path.CGPath;
    CABasicAnimation *showAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    showAnimation.fromValue = @0;
    showAnimation.toValue = @1;
    showAnimation.duration = DURATION;
    showAnimation.removedOnCompletion = YES;
    showAnimation.fillMode = kCAFillModeForwards;
    [self.layer addSublayer:self.lineLayer];
    [self.lineLayer addAnimation:showAnimation forKey:@"kClockAnimation"];
}


@end
