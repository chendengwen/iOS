//
//  HMViewController.m
//  10-UIView封装的动画
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;

@property (nonatomic, assign) int index;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _index = 1;
}

// 核心动画都是假象，不能改变layer的真实属性的值
// 展示的位置和实际的位置不同。实际位置永远在最开始位置
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    _index++;
    
    if (_index == 4) {
        _index = 1;
    }
    NSString *fileName = [NSString stringWithFormat:@"%d",_index];
    _iamgeView.image = [UIImage imageNamed:fileName];
  
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];

}

- (void)position
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"position";
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    
    anim.delegate = self;
    
    // 取消反弹
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [_redView.layer addAnimation:anim forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@",NSStringFromCGPoint(_redView.layer.position));
}


@end
