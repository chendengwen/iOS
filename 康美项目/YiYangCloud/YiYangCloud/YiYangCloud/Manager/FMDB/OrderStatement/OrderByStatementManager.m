//
//  OrderByStatementManager.m
//  DBTest
//
//  Created by paidui-mini on 13-10-21.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

#import "OrderByStatementManager.h"
#import "OrderByStatement.h"

@implementation OrderByStatementManager
@synthesize orderByStatments = _orderByStatments;

- (void)dealloc
{
    self.orderByStatments = nil;
}

- (NSMutableArray *)orderByStatments
{
    if (_orderByStatments == nil)
    {
        _orderByStatments = [[NSMutableArray alloc] init];
    }
    return _orderByStatments;
}

- (NSString *)orderType:(SelectOrderByType)type
{
    NSString *orderDescription;
    switch (type) {
        case SelectOrderByDesc:
        {
            orderDescription = [NSString stringWithFormat:@"desc"];
        }
            break;
        case SelectOrderByAsc:
        {
            orderDescription = [NSString stringWithFormat:@"asc"];
        }
            break;
        default:
            break;
    }
    return orderDescription;
}

- (NSString *)orderBySql
{
    NSMutableString *sql = [NSMutableString string];
    for (int i=0; i<self.orderByStatments.count; i++)
    {
        if (i>0)
        {
            [sql appendString:@","];
        }
        OrderByStatement *statement = (OrderByStatement *)[self.orderByStatments objectAtIndex:i];
        [sql appendFormat:@"%@ ",statement.key];
        [sql appendFormat:@"%@",[self orderType:statement.orderByType]];
    }
    return sql;
}

@end
