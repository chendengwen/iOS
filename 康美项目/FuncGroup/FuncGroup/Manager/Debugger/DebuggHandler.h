//
//  Debugger.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GAssert.h"

#define DebugFormatStr(...)   [NSString stringWithFormat:__VA_ARGS__]

#ifdef Debug

#define GErrorLog(message) [DebuggHandler logErrorMessage:(message)]

#else

#define GErrorLog(message) ((void)0)

#endif


@interface DebuggHandler : NSObject

+(void)logErrorMessage:(NSString *)message;

@end
