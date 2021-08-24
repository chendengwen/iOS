//
//  GAssert.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief 断言， 调试模式下有效, nimbus
 */
#ifdef DEBUG

#import <TargetConditionals.h>

/*!
 @brief DubugLog, 用于输出最详细信息
 */
#define DubugLog(log, ...) NSLog((@"%s [Line %d] " log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

extern BOOL GBeingDebugged(void);

#if TARGET_IPHONE_SIMULATOR
// We leave the __asm__ in this macro so that when a break occurs, we don't have to step out of
// a "breakInDebugger" function.
#define GASSERT(xx) { if (!(xx)) { DubugLog(@"PDASSERT failed: %s", #xx); \
if (GBeingDebugged()) { __asm__("int $3\n" : : ); } } \
} ((void)0)
#else
#define GASSERT(xx) { if (!(xx)) { DubugLog(@"PDASSERT failed: %s", #xx); \
if (GBeingDebugged()) { raise(SIGTRAP); } } \
} ((void)0)
#endif // #if TARGET_IPHONE_SIMULATOR


#else

#define GASSERT(xx) ((void)0)



#endif
