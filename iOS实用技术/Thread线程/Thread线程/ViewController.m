//
//  ViewController.m
//  Thread线程
//
//  Created by 陈登文 on 2021/8/27.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL _working;
}
@property(strong) NSThread *thread1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _working = YES;
    _thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(threadRoutine) object:nil];
    [_thread1 start];
    
    
}

//子线程入口 -- 常驻线程
-(void)threadRoutine{
    @autoreleasepool {
        // 添加持续事件源，就可以开启RunLoop，之后_thread1就变成了常驻线程，可随时添加任务，并交于RunLoop处理
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        while (_working) {
            CFRunLoopRef ref = CFRunLoopGetCurrent();
            CFRunLoopStop(ref);
            //设置超时参数，控制runloop运行时间，隔一段时间退出runloop循环提供检查运行条件的机会
            [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
            CFRunLoopStop(ref);
            // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环
            NSLog(@"runloop 关闭 %d",1);
        }
    }
}

/*
runloop 无法通过 CFRunLoopStop() 停止，只能通过控制 source 和 有效期 控制
 run
 runUntilDate: 限定有效期，底层是invoke的runMode:beforeDate:
 runMode:beforeDate: 限定mode和有效期，要么runloop循环一次停止，要么到期停止
 
 */

@end
