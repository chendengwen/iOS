//
//  BaseDBController.m
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseDBController.h"
#import "DataBaseManager.h"


@implementation BaseDBController

- (FMDatabaseQueue *)dbQueue
{
    return [DataBaseManager sharedDataBaseManager].dbQueue;
}

+ (instancetype)dbController
{
    return [[self alloc] init];
}

- (id)init
{
    if (self = [super init])
    {
        _dbHelper = [[BaseDBHelper alloc] init];
    }
    return self;
}


@end
