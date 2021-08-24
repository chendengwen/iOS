//
//  RunLoop.m
//  FuncGroup
//
//  Created by gary on 2017/3/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "RunLoop.h"

void AddRunLoopObserver(void *obj){
    // 拿到当前runLoop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    // 上下文
    CFRunLoopObserverContext context = {
        0,
        obj,
        &CFRetain,
        &CFRelease,
        NULL
    };
    // 创建观察者
    static CFRunLoopObserverRef observer;
    observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &CallBack, &context);
    // 添加观察者
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopDefaultMode);
    //
    CFRelease(observer);
}
