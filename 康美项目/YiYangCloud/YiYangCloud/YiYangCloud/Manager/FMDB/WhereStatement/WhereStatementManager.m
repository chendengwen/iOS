//
//  WhereStatementManager.m
//  DBTest
//
//  Created by paidui-mini on 13-10-18.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

#import "WhereStatementManager.h"
#import "WhereStatement.h"
#import "NSObject+Property.h"

@implementation WhereStatementManager

@synthesize expressions = _expressions;
@synthesize values = _values;

- (void)dealloc
{
    self.expressions = nil;
    self.values = nil;
}

- (NSMutableArray *)expressions
{
    if (_expressions == nil)
    {
        _expressions = [[NSMutableArray alloc] init];
    }
    return _expressions;
}

- (NSMutableArray *)values
{
    if(_values == nil)
    {
        _values = [[NSMutableArray alloc] init];
    }
    return _values;
}

- (NSString *)linkType:(SqlLinkRelationShipType)type
{
    NSString *linkType = nil;
    switch (type)
    {
        case SqlLinkRelationshipAnd:
        {
            linkType = [NSString stringWithFormat:@"and"];
        }
            break;
        case SqlLinkRelationShipOr:
        {
            linkType = [NSString stringWithFormat:@"or"];
        }
            break;
        default:
        {
            linkType = [NSString stringWithFormat:@""];
        }
            break;
    }
    return linkType;
}

- (NSString *)operation:(SqlOperationType)type
{
    NSString *operation = nil;
    
    switch (type)
    {
        case SqlOperationEqual:
        {
            operation = [NSString stringWithFormat:@"="];
        }
            break;
        case SqlOperationInEqual:
        {
            operation = [NSString stringWithFormat:@"!="];
        }
            break;
        case SqlOperationGreater:
        {
            operation = [NSString stringWithFormat:@">"];
        }
            break;
        case SqlOperationLess:
        {
            operation = [NSString stringWithFormat:@"<"];
        }
            break;
        case SqlOperationGreaterAndEqual:
        {
            operation = [NSString stringWithFormat:@">="];
        }
            break;
        case SqlOperationLessAndEqual:
        {
            operation = [NSString stringWithFormat:@"<="];
        }
            break;
        case SqlOperationBetween:
        {
            operation = [NSString stringWithFormat:@"between"];
        }
            break;
        case SqlOperationLike:
        {
            operation = [NSString stringWithFormat:@"like"];
        }
            break;
            
        default:
        {
            operation = [NSString stringWithFormat:@""];
        }
            break;
    }
    
    return operation;
}

// 返回sql语句的where部分语句
- (NSString *)whereSql:(NSObject *)object
{
    NSMutableString *whereString = [NSMutableString string];
    
    for (int i=0; i<self.expressions.count; i++)
    {
        WhereStatement *statement = (WhereStatement *)[self.expressions objectAtIndex:i];
        NSArray *properties = [object getPropertyList];
        
        if (![properties containsObject:statement.key]) continue;
        
        [whereString appendFormat:@"%@",statement.key];
        
        [whereString appendFormat:@" %@ ",[self operation:statement.operationType]];
        //  ＝ > 后面没有接参数  ？？？？？？？？
        
        id propertyValue = [object valueForKey:statement.key];
        
        if (propertyValue == nil)
        {
            propertyValue = @"";
        }
        [self.values addObject:propertyValue];
        
        [whereString appendString:@"?"];
        if (i != self.expressions.count-1)
        {
            [whereString appendFormat:@" %@ ",[self linkType:statement.linkType]];
        }
    }
    DebugFormatStr(@"wherestring is %@",whereString);
    return whereString;
}

@end
