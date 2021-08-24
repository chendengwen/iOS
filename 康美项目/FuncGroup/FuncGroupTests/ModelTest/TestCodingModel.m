//
//  TestCodingModel.m
//  FuncGroup
//
//  Created by gary on 2017/3/3.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "TestCodingModel.h"

@implementation TestCodingModel

-(NSString *)testSomeFunction:(NSString *)testParam{

    NSLog(@"testSomeFunction ---- %@",testParam);
    return @"123 success";
}

@end
