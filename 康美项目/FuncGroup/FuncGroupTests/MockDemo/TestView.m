//
//  TestView.m
//  FuncGroup
//
//  Created by gary on 2017/3/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "TestView.h"

@implementation TestView

-(void)addModel:(TestModel *)model{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    [_dataArray addObject:model];
}

@end
