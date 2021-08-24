//
//  HMViewController.m
//  05-CABasicAnimation
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
    
    layer.position = CGPointMake(100, 100);
    
    layer.bounds = CGRectMake(0, 0, 100, 100);
    
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    layer.contents = (id)[UIImage imageNamed:@"心"].CGImage;
    
    [self.view.layer addSublayer:layer];
    
    _layer = layer;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 设置动画的属性
    anim.keyPath = @"transform.scale";
    
    // 设置属性改变的值
    anim.toValue = @0.5;
    
    // 设置动画时长
    anim.duration = 0.25;
    
    // 取消反弹
    // 动画执行完毕之后不要把动画移除
    anim.removedOnCompletion = NO;
    
    // 保持最新的位置
    anim.fillMode = kCAFillModeForwards;
    
    // 重复动画的次数
    anim.repeatCount = MAXFLOAT;
    
    // 给图层添加了动画
    [_layer addAnimation:anim forKey:nil];

}

- (void)position
{
    // 创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 设置动画的属性
    anim.keyPath = @"position";
    
    // 设置属性改变的值
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    
    // 设置动画时长
    anim.duration = 2;
    
    // 取消反弹
    // 动画执行完毕之后不要把动画移除
    anim.removedOnCompletion = NO;
    
    // 保持最新的位置
    anim.fillMode = kCAFillModeForwards;
    
    // 给图层添加了动画
    [_layer addAnimation:anim forKey:nil];
}


@end
