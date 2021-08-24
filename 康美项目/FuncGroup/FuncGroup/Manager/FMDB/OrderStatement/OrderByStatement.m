//
//  OrderByStatement.m
//  DBTest
//
//  Created by paidui-mini on 13-10-18.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

#import "OrderByStatement.h"

@implementation OrderByStatement

@synthesize key,orderByType;

- (void)dealloc
{
    self.key = nil;
}

+ (OrderByStatement *)instance
{
    return [[[self class] alloc] init];
}

+ (OrderByStatement *)instanceWithKey:(NSString *)mKey
{
    OrderByStatement *statement = [OrderByStatement instance];
    statement.key = mKey;
    statement.orderByType = SelectOrderByAsc;
    return statement;
}

+ (OrderByStatement *)instanceWithKey:(NSString *)mKey OrderByType:(SelectOrderByType)mType
{
    OrderByStatement *statement = [OrderByStatement instance];
    statement.key = mKey;
    statement.orderByType = mType;
    return statement;
}

@end
