//
//  HMViewController.m
//  03-隐世动画
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()

@property (nonatomic, weak) CALayer *layer;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CALayer *layer = [CALayer layer];
    
    // 设置尺寸
    layer.bounds = CGRectMake(0, 0, 100, 100);
    
    // 颜色
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    [self.view.layer addSublayer:layer];
    
    _layer = layer;
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取触摸点
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:self.view];
    
    // 开启事务
//    [CATransaction begin];
    
    // 取消隐世动画
//    [CATransaction setDisableActions:YES];
//    _layer.position = CGPointMake(100, 100);
    
    // 设置边框
    _layer.borderWidth = arc4random_uniform(5) + 1;
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
//    _layer.borderColor = [UIColor colorWithRed:r green:g blue:b alpha:1].CGColor;
    
    // 设置背景颜色
    _layer.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1].CGColor;
    
    // 设置圆角半径
    _layer.cornerRadius = arc4random_uniform(50);
    
    // 设置位置
    _layer.position = pos;
    
    // 提交事务
//    [CATransaction commit];
}



@end
