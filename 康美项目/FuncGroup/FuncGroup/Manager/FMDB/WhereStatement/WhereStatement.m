//
//  WhereStatement.m
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "WhereStatement.h"

@implementation WhereStatement

@synthesize key,operationType,linkType;

- (void)dealloc
{
    self.key = nil;
}

+ (WhereStatement *)instance
{
    return [[[self class] alloc]init];
}

+ (WhereStatement *)instanceWithKey:(NSString *)mkey
{
    return [self instanceWithKey:mkey
                       operation:SqlOperationEqual
                    relationShip:SqlLinkRelationshipAnd];
}

+ (WhereStatement *)instanceWithKey:(NSString *)mkey operation:(SqlOperationType)mType
{
    return [self instanceWithKey:mkey
                       operation:mType
                    relationShip:SqlLinkRelationshipAnd];
}

+ (WhereStatement *)instanceWithKey:(NSString *)mkey
                          operation:(SqlOperationType)mOperationType
                       relationShip:(SqlLinkRelationShipType)mlinkType
{
    WhereStatement *statement = [WhereStatement instance];
    statement.key = mkey;
    statement.operationType = mOperationType;
    statement.linkType = mlinkType;
    return statement;
}


@end
