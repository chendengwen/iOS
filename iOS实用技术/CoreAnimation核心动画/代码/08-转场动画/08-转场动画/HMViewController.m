//
//  HMViewController.m
//  08-转场动画
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) int index;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _index = 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _index++;
    
    if (_index == 4) {
        _index = 1;
    }
    NSString *fileName = [NSString stringWithFormat:@"%d",_index];
    _imageView.image = [UIImage imageNamed:fileName];
    
    CATransition *anim = [CATransition animation];
    
    anim.type = @"pageCurl";
    
    anim.subtype = kCATransitionFromLeft;
//    anim.startProgress = 0.5;
    
    anim.duration = 2;
    
    [_imageView.layer addAnimation:anim forKey:nil];
}

@end
