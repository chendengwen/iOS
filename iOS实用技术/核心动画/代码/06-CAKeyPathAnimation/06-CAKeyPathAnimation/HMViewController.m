//
//  HMViewController.m
//  06-CAKeyPathAnimation
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    // 设置动画属性
    anim.keyPath = @"position";
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    
    anim.path = path.CGPath;
    
    anim.duration = 0.25;
    
    // 取消反弹
    anim.removedOnCompletion = NO;
    
    anim.fillMode = kCAFillModeForwards;
    
    anim.repeatCount = MAXFLOAT;
    
    [_redView.layer addAnimation:anim forKey:nil];

}
- (void)value
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    // 设置动画属性
    anim.keyPath = @"position";
    
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointZero];
    
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(160, 160)];
    
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(270, 0)];
    
    anim.values = @[v1,v2,v3];
    
    anim.duration = 2;
    
    [_redView.layer addAnimation:anim forKey:nil];
}


@end
