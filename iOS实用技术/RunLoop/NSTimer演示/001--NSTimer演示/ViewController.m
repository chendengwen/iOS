//
//  ViewController.m
//  001--NSTimer演示
//
//  Created by H on 17/1/12.
//  Copyright © 2017年 H. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     NSDefaultRunLoopMode;  - 时钟,网络事件
     NSRunLoopCommonModes;  - 用户交互
     */
   NSTimer * timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updataTimer) userInfo:nil repeats:YES];
    
    //加入运行循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:(NSRunLoopCommonModes)];
    
    //默认就是NSDefaultRunLoopMode 模式
    //scheduledTimerWithTimeInterval 创建的timer自动加入 currentRunLoop
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updataTimer) userInfo:nil repeats:YES];
    
}

-(void)updataTimer{
    //如果时钟出发的方法,执行非常耗时!注意不能再时钟调用法中,执行耗时的操作
    NSLog(@"睡会");
    [NSThread sleepForTimeInterval:1.0];
    
    
    NSLog(@"%@",[NSThread currentThread]);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
