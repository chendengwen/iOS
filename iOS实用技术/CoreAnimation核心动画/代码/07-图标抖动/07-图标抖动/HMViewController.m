//
//  HMViewController.m
//  07-图标抖动
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

#define angle2radian(x) ((x) / 180.0 * M_PI)

@interface HMViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [_imageView addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        
        anim.keyPath = @"transform.rotation";
        
        anim.values = @[@(angle2radian(-5)),@(angle2radian(5)),@(angle2radian(-5))];
        
        anim.repeatCount = MAXFLOAT;
        
        anim.duration = 0.5;
        
        [_imageView.layer addAnimation:anim forKey:nil];
        
    }
}


@end
