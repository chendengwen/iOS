//
//  HMViewController.m
//  02-自定义图层
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 创建一个图层
    CALayer *layer = [CALayer layer];
    
    // 设置尺寸
    layer.bounds = CGRectMake(0, 0, 100, 100);
    
    // 设置位置
    layer.position = CGPointMake(100, 100);
    
    // 设置颜色
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    // 设置内容
    layer.contents = (__bridge id)[UIImage imageNamed:@"阿狸头像"].CGImage;
    
    
    [self.view.layer addSublayer:layer];
    
}



@end
