//
//  Debugger.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DebuggHandler.h"

@implementation DebuggHandler

+(void)logErrorMessage:(NSString *)message{
    NSLog(@"%@", [NSString stringWithFormat:@"%s  %s  %d : %@",__FILE__, __PRETTY_FUNCTION__, __LINE__, message]);
}

@end
