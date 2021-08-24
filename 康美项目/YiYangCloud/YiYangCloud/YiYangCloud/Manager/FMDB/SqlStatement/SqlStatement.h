//
//  SqlStatement.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseModel;
@interface SqlStatement : NSObject

@property (nonatomic, strong) NSMutableArray *sqlValues;

/*!
 @brief     查询多个id的name, 查询条件是传入的多个id
 @param     idColumn id 的列名
 @param     nameColume name 的列名的名字
 @param     tableName 表名
 @param     inIds 查询条件,拼接成'id1','id2','id3'
 @return    NSString
 */
+ (NSString *)sqlSelectId:(NSString *)idColumn
                     Name:(NSString *)nameColume
            FromTableName:(NSString *)tableName
                    ByIDs:(NSString *)inIds;


/*！
 @brief  查找对应行的数据
 @prama  mColumns：对应具体的行（必须为a.b的形式，a为实体类名，b为属性)
 @prama  model: 数据库表实体类
 @prama  expressions：限制对应行的语句
 @prama  orderBystatements：sql语句中的orderBy表达式
 @prama  mLimit：sql语句的limit部分
 @prama  mOffset：sql语句的offset部分
 @return 查询对应行的sql语句
 */
- (NSString *)selectSqlfromCloumns:(NSArray *)mColumns
                        tableModel:(BaseModel *)model
                             where:(NSArray *)expressions
                           orderBy:(NSArray *)orderBystatements
                             limit:(NSInteger)mLimit
                            offset:(NSInteger)mOffset;

/*
 @brief  更新对应行的表数据
 @prama  model：对应的表实体类
 @prama  mColumns:需更新的具体字段
 @prama  expressions: 限制对应行的语句
 @return 更新对应行的sql语句
 */
- (NSString *)updateTableModel:(BaseModel *)model
                    setColumns:(NSArray *)mColumns
                         where:(NSArray *)expressions;

/*
 @brief  删除对应行的表数据
 @prama  model：对应的表实体类
 @prama  expressions: 限制对应行的语句，wExpressionManager为空删除整张表
 @return 删除表数据的sql语句
 */
- (NSString *)deleteTableModel:(BaseModel *)model
                         where:(NSArray *)expressions;


/*
 @brief  对表的若干字段自动进行插入
 @prama  model：对应的表实体类
 @prama  mColumns：需插入的具体的字段
 @return 对整张表的自动进行插入的sql语句
 */
- (NSString *)insertTableModel:(BaseModel *)model
                       columns:(NSArray *)mColumns;

@end
