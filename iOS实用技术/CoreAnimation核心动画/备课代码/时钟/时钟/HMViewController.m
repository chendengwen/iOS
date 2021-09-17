//
//  HMViewController.m
//  时钟
//
//  Created by yz on 14-9-5.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import "HMViewController.h"

#define HMColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

// 每秒秒针转多少度
#define  perSecondA  6

// 每分转分针多少度
#define  perMinuteA  6

// 每小时时钟转多少度
#define  perHourA  30

// 每分钟时针转多少度
#define perMinuteHourA 0.5




#define angle2radian(x) ((x) / 180.0 * M_PI)

@interface HMViewController ()
{
    CALayer *_second;
    CALayer *_minute;
    CALayer *_hour;
}
@property (weak, nonatomic) IBOutlet UIImageView *clockView;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 小时
    [self addHour];
    
    // 分钟
    [self addMinute];


    // 秒针
    [self addSecond];
    
    
    
    // 创建定时器
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    [self update];
}

// 小时
- (void)addHour
{
    CGFloat clockW = _clockView.bounds.size.width;
    CGFloat clockH = _clockView.bounds.size.height;
    
    // 1.秒针
    CALayer *hour = [CALayer layer];
    
    // 设置锚点
    hour.anchorPoint = CGPointMake(0.5, 1);
    
    // 设置位置
    hour.position = CGPointMake(clockW * 0.5, clockH * 0.5);
    
    // 设置尺寸
    hour.bounds = CGRectMake(0, 0, 5, clockH * 0.5 - 50);
    
    // 设置颜色
    hour.backgroundColor = HMColor(76, 102, 155).CGColor;
    
    // 设置圆角半径
    hour.cornerRadius = 5;

    
    [_clockView.layer addSublayer:hour];
    
    _hour = hour;
    
}

// 分钟
- (void)addMinute
{
    CGFloat clockW = _clockView.bounds.size.width;
    CGFloat clockH = _clockView.bounds.size.height;
    
    // 1.秒针
    CALayer *minute = [CALayer layer];
    
    // 设置锚点
    minute.anchorPoint = CGPointMake(0.5, 1);
    
    // 设置位置
    minute.position = CGPointMake(clockW * 0.5, clockH * 0.5);
    
    // 设置尺寸
    minute.bounds = CGRectMake(0, 0, 3, clockH * 0.5 - 27);
    
    // 设置圆角半径
    minute.cornerRadius = 3;
    
    // 设置颜色
    minute.backgroundColor = HMColor(74, 100, 154).CGColor;
    
    [_clockView.layer addSublayer:minute];
    
    _minute = minute;

}

// 秒针
- (void)addSecond
{
    CGFloat clockW = _clockView.bounds.size.width;
    CGFloat clockH = _clockView.bounds.size.height;
    
    // 1.秒针
    CALayer *second = [CALayer layer];
    
    // 设置锚点
    second.anchorPoint = CGPointMake(0.5, 1);
    
    // 设置位置
    second.position = CGPointMake(clockW * 0.5, clockH * 0.5);
    
    // 设置尺寸
    second.bounds = CGRectMake(0, 0, 1, clockH * 0.5 - 20);
    
    // 设置颜色
    second.backgroundColor = HMColor(252, 175, 35).CGColor;
    
    // 设置圆角半径
    second.cornerRadius = 1;

    
    [_clockView.layer addSublayer:second];
    
    _second = second;

}

- (void)update
{
    // 获取当前秒数
    // 获取当前秒数日历对象
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    // 获取日期组成对象，根据当前日期。
    // components:日期组成元素（时分秒等）
    NSDateComponents *components = [calender components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    
    // 获取秒数
    CGFloat sec = components.second;
    CGFloat minute = components.minute;
    CGFloat hour = components.hour;
    
    // 计算秒针旋转角度
    CGFloat secondA = sec * perSecondA;
    
    // 计算分钟旋转角度
    CGFloat minuteA = minute * perMinuteA;
    
    // 计算时钟旋转角度
    CGFloat hourA = hour * perHourA;
    // 加上每一分钟旋转的角度
    hourA += minute * perMinuteHourA;
    
    // 旋转秒针
    _second.transform = CATransform3DMakeRotation(angle2radian(secondA), 0, 0, 1);
    
    // 旋转分针
    _minute.transform = CATransform3DMakeRotation(angle2radian(minuteA), 0, 0, 1);

    // 旋转时针
    _hour.transform = CATransform3DMakeRotation(angle2radian(hourA), 0, 0, 1);


}



@end
