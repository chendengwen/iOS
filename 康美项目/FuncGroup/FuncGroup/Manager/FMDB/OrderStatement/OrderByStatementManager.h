//
//  OrderByStatementManager.h
//  DBTest
//
//  Created by paidui-mini on 13-10-21.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

@import Foundation;

@interface OrderByStatementManager : NSObject

@property (nonatomic, strong) NSMutableArray *orderByStatments;

- (NSString *)orderBySql;

@end
