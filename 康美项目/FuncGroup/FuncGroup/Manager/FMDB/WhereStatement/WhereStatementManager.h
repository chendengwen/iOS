//
//  WhereStatementManager.h
//  DBTest
//
//  Created by paidui-mini on 13-10-18.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

@import Foundation;

@interface WhereStatementManager : NSObject

/*!
 @brief  存放所有需要的表达式
 */
@property (nonatomic, strong) NSMutableArray *expressions;
/*!
 @brief  存放所有需要的where部分的值
 */
@property (nonatomic, strong) NSMutableArray *values;

/*!
 @brief  返回sql语句的where部分语句
 @prama  object：对应的表实体对象
 @return sql语句的where部分
 */
- (NSString *)whereSql:(NSObject *)object;

@end
