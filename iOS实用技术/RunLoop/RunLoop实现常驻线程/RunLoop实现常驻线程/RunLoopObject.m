//
//  RunLoopObject.m
//  RunLoop实现常驻线程
//
//  Created by 陈登文 on 2021/8/25.
//

#import "RunLoopObject.h"


@interface RunLoopObject()
@end

extern BOOL runAlways = YES;

@implementation RunLoopObject

NSThread *thread;

+(NSThread *)threadDispatch{
    if (thread == nil) {
        @synchronized (self) {
            if (thread == nil) {
                thread = [[NSThread alloc] initWithTarget:self selector:@selector(runRequest_cycle) object:nil];
                [thread setName:@"runloop_object"];
                [thread start];
            }
        }
    }
    return thread;
}

+(void)runRequest_once{
    NSLog(@"runRequest_once current thread == %p, name == %@", [NSThread currentThread], [NSThread currentThread].name);
}

+(void)runRequest_cycle{
    //创建一个source
    CFRunLoopSourceContext context = {0,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    NSBlockOperation *ss;
    //创建RunLoop(线程默认没有ruloop，第一次读取时创建)
    //同时向RunLoop的DefaultMode下添加source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
//    NSLog(@"%@",[NSRunLoop currentRunLoop]);
    CFRunLoopSourceRef ref;
    //保持运行
//    while (runAlways) {
//        @autoreleasepool {
//            //令当前RunLoop运行在DefaultMode下
//            NSLog(@"runRequest_cycle");
//            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, true);
//
//        }
//    }
    CFRunLoopRun();
    
    //某一个时刻，静态变量 runAlways = NO，可以保证跳出runloop，线程结束
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
}

@end
