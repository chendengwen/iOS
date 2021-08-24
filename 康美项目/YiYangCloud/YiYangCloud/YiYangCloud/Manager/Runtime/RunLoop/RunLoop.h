//
//  RunLoop.h
//  FuncGroup
//
//  Created by gary on 2017/3/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^RunLoopBlock)(void);

/*!
 @brief 回调，调用类必须实现 ！！！！
 */
void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

void AddRunLoopObserver(void *obj);
