//
//  ViewController.m
//  GCD使用示例
//
//  Created by gary on 2021/9/1.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}

/*
 ** 异步队列 + 异步任务
 */
-(void)asyncQueue_asyncTask{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue2 = dispatch_queue_create("com.juejin.cn", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"第一个任务 - %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue1, ^{
        dispatch_async(queue2, ^{
            sleep(1);
            NSLog(@"第二个任务的子任务 - %@", [NSThread currentThread]);
        });
        NSLog(@"第二个任务 - %@", [NSThread currentThread]);
    });
    
    //等待上面的任务全部完成后，会往下继续执行 （会阻塞当前线程）
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"两个任务都完成了 - %@", [NSThread currentThread]);
    });
}

/*
 ** 异步队列 + 同步任务
 */
-(void)asyncQueue_syncTask{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("dispatchGroupMethod1.queue1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        dispatch_sync(queue, ^{
            for (NSInteger i =0; i<3; i++) {
                sleep(1);
                NSLog(@"%@-同步任务执行-:%ld - %@",@"任务1",(long)i,[NSThread currentThread]);
            }
        });
    });
    dispatch_group_async(group, queue, ^{
        dispatch_sync(queue, ^{
            for (NSInteger i =0; i<3; i++) {
                sleep(1);
                NSLog(@"%@-同步任务执行-:%ld - %@",@"任务2",(long)i,[NSThread currentThread]);
            }
        });
    });

    //等待上面的任务全部完成后，会往下继续执行 （会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"%@-同步任务执行-:%d - %@",@"任务2",11,[NSThread currentThread]);
    
    //等待上面的任务全部完成后，会收到通知执行block中的代码 （不会阻塞线程）
    dispatch_group_notify(group, queue, ^{
        NSLog(@"Method1-全部任务执行完成");
    });
}


@end
