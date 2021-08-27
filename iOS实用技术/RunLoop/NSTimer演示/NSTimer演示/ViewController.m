//
//  ViewController.m
//  001--NSTimer演示
//
//  Created by H on 17/1/12.
//  Copyright © 2017年 H. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSThread *_thread;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_mainThread]; //主线程
    [self test_multiThread]; //子线程
    
}

-(void)test_mainThread{
    /*
     NSDefaultRunLoopMode;  - 时钟,网络事件
     UITrackingRunLoopMode; - UI模式
     NSRunLoopCommonModes;  - 兼容模式，包含 default 和 UI
     */
    NSTimer * timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timedTask) userInfo:nil repeats:YES];
    //加入运行循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:(NSRunLoopCommonModes)];
}

-(void)test_multiThread{
    // 子线程启动定时器
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTask) object:nil];
    [_thread setName:@"timer thread"];
    [_thread start];
    //或者
//    [NSThread detachNewThreadSelector:@selector(createTimer) toTarget:self withObject:nil];
}

//定时器子线程入口
-(void)threadTask{
    NSLog(@"main %@",[NSThread mainThread]);
    NSLog(@"current %@",[NSThread currentThread]);
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timedTask) userInfo:nil repeats:NO];
    //注意这里的NO，执行完1次任务后runloop就停止了；如果要继续在线程里执行某个任务，需要在定时任务里再run一次
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"-~~~~~~~~~~~~~~执行完1次任务后runloop停止~~~~~~~~~~~~~~~~~~~~");
}

-(void)timedTask{
    NSLog(@"-----------执行定时任务-----------");

    //在这里再run一次才能让线程继续处理任务，不然会崩溃，为啥？？
    {
    /*
     分析：
     崩溃：不重复的定时器任务就和普通任务一样，线程任务执行完了就死亡了(-exit)，不能再次开启任务；runloop没有source，执行run也是立即退出循环了。
     不崩溃：在定时任务里执行run，起到了绑定source的作用，原理不清楚。。。
     */
//    [[NSRunLoop currentRunLoop] run];
//    NSLog(@"-~~~~~~~~~~~~~~不会执行~~~~~~~~~~~~~~~~~~~~");
    }
}

//UI时间-主线程
- (IBAction)buttonClicked:(id)sender {
    [self performSelector:@selector(newThreadTask) onThread:_thread withObject:nil waitUntilDone:YES];
}

-(void)newThreadTask{
    NSLog(@"-----------------线程执行新任务-------------------");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
