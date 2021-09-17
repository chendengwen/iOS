//
//  HMViewController.m
//  04-时钟
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

// 每秒秒针转6度
#define perSecendA 6

// 每分钟分针转6度
#define perMinuteA 6

// 每小时时针转6度
#define perHourA 30

// 每分钟时针转6度
#define perMinuteHourA 0.5

#define angle2radian(x) ((x) / 180.0 * M_PI)

@interface HMViewController ()
{
    CALayer *_second;
    CALayer *_minute;
    CALayer *_hour;
}
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIImageView *clockView;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 1.添加秒针
    [self addSecond];
    
    // 2.添加分针
    [self addMintue];
    
    // 3.添加时针
    [self addHour];
   
    
    // 创建定时器
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    
    [self update];
}

- (void)addHour
{
    CGFloat imageW = _clockView.bounds.size.width;
    CGFloat imageH = _clockView.bounds.size.height;
    
    // 1.添加时针
    CALayer *hour = [CALayer layer];
    
    // 2.设置锚点
    hour.anchorPoint = CGPointMake(0.5, 1);
    
    // 3.设置位置
    hour.position = CGPointMake(imageW * 0.5, imageH * 0.5);
    
    // 4.设置尺寸
    hour.bounds = CGRectMake(0, 0, 4, imageH * 0.5 - 50);
    
    // 5.红色
    hour.backgroundColor = [UIColor blackColor].CGColor;
    
    hour.cornerRadius = 4;
    
    // 添加到图层上
    [_clockView.layer addSublayer:hour];
    
    _hour = hour;
}

// 添加分针
- (void)addMintue
{
    CGFloat imageW = _clockView.bounds.size.width;
    CGFloat imageH = _clockView.bounds.size.height;
    
    // 1.添加分针
    CALayer *minute = [CALayer layer];
    
    // 2.设置锚点
    minute.anchorPoint = CGPointMake(0.5, 1);
    
    // 3.设置位置
    minute.position = CGPointMake(imageW * 0.5, imageH * 0.5);
    
    // 4.设置尺寸
    minute.bounds = CGRectMake(0, 0, 2, imageH * 0.5 - 30);
    
    // 5.红色
    minute.backgroundColor = [UIColor blueColor].CGColor;
    
    // 添加到图层上
    [_clockView.layer addSublayer:minute];
    
    _minute = minute;
}

// 添加秒针
- (void)addSecond
{
    CGFloat imageW = _clockView.bounds.size.width;
    CGFloat imageH = _clockView.bounds.size.height;
    
    // 1.添加秒针
    CALayer *second = [CALayer layer];
    
    // 2.设置锚点
    second.anchorPoint = CGPointMake(0.5, 1);
    
    // 3.设置位置
    second.position = CGPointMake(imageW * 0.5, imageH * 0.5);
    
    // 4.设置尺寸
    second.bounds = CGRectMake(0, 0, 1, imageH * 0.5 - 20);
    
    // 5.红色
    second.backgroundColor = [UIColor redColor].CGColor;
    
    // 添加到图层上
    [_clockView.layer addSublayer:second];
    
    _second = second;
}

- (void)update
{
    // 获取秒数
    // 获取日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取日期组件
    NSDateComponents *compoents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    
    // 获取秒数
    CGFloat sec = compoents.second;
    
    // 获取分钟
    CGFloat minute = compoents.minute;
    
    // 获取小时
    CGFloat hour = compoents.hour;

    
    // 算出秒针旋转多少°
    CGFloat secondA = sec * perSecendA;
    
    // 算出分针旋转多少°
    CGFloat minuteA = minute * perMinuteA;
    
    // 算出时针旋转多少°
    CGFloat hourA = hour * perHourA;
    hourA += minute * perMinuteHourA;
    
    // 旋转秒针
    _second.transform = CATransform3DMakeRotation(angle2radian(secondA), 0, 0, 1);
    
    // 旋转分针
    _minute.transform = CATransform3DMakeRotation(angle2radian(minuteA), 0, 0, 1);
    
    // 旋转时针
    _hour.transform = CATransform3DMakeRotation(angle2radian(hourA), 0, 0, 1);

}




@end
