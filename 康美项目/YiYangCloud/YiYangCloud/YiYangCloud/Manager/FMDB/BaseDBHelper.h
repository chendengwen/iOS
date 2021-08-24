//
//  BaseDBHelper.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "FMDatabaseQueue.h"

@interface BaseDBHelper : NSObject

/*!
 @brief  根据对应的sql语句，查询表所有字段的信息
 @prama  model: 数据库表实体类
 @prama  expressions：sql语句中的where表达式
 @return 返回对应表实体的集合
 */
- (NSArray *)queryAllToModel:(BaseModel *)model
                       where:(NSArray *)expressions;

/*!
 @brief  根据对应的sql语句，查询出对应的数据库实体的集合
 @prama  model: 数据库表实体类
 @prama  cloumns：对应查询的表字段
 @prama  expressions：sql语句中的where表达式
 @return 返回对应表实体的集合
 */
- (NSArray *)queryDBToModel:(BaseModel *)model
                    columns:(NSArray *)columns
                      where:(NSArray *)expressions;

/*!
 @brief  根据对应的sql语句，查询出对应的数据库实体的集合
 @prama  model: 数据库表实体类
 @prama  cloumns：对应查询的表字段
 @prama  expressions：sql语句中的where表达式
 @prama  orderStatements：sql语句中的orderBy表达式
 @prama  limit：sql语句的limit部分
 @prama  offset：sql语句的offset部分
 @return 返回对应表实体的集合
 */
- (NSArray *)queryDbToModel:(BaseModel *)model
                    cloumns:(NSArray *)cloumns
                      where:(NSArray *)expressions
                    orderBy:(NSArray *)orderStatements
                      limit:(NSInteger)mLimit
                     offset:(NSInteger)mOffset;

/*!
 @brief  根据dic的键值批量更新数据库
 @prama  model: 数据库表实体类
 @prama  columns:更新的行
 @prama  expressionsn：sql更新语句中的where表达式
 @return 更新成功返回Yes，否则返回NO
 */
- (BOOL)updateDbByTableModels:(NSArray *)models
                   setColumns:(NSArray *)columns
                        where:(NSArray*)expressions;

/*!
 @brief  删除数据库数据
 @prama  model: 数据库表实体类
 @prama  expressions：删除语句中的where表达式 expression为空删除整张表数据
 @return 删除成功返回Yes，否则返回NO
 */
- (BOOL)deleteDbByTableModels:(NSArray *)models where:(NSArray *)expressions;

/*!
 @brief  插入整张表的字段的数据
 @prama  model: 数据库实体类
 @return 插入成功返回Yes，否则返回NO
 */
- (BOOL)insertAllByTableModels:(NSArray *)models;

/*!
 @brief  数据库具体的字段插入值
 @prama  model: 数据库实体类
 @prama  cloumns:key对应数据库对应的字段 value对应具体的值
 @return 插入成功返回Yes，否则返回NO
 */
- (BOOL)insertDbByTableModels:(NSArray *)models columns:(NSArray *)mColumns;

/*!
 @brief  根据对应的sql语句，查询出对应的数据库实体的集合
 @prama  model:数据库表实体
 @prama sqlStament：sql语句
 @prama arguments：sql语句中的参数
 */
- (NSArray *)executeToModel:(BaseModel *)model
                        sql:(NSString *)sqlStament
              withArguments:(NSArray *)arguments;

/*!
 @brief     资料继承该方法，操作指定数据库
 */
- (FMDatabaseQueue *)instanceDBQueue;

@end
