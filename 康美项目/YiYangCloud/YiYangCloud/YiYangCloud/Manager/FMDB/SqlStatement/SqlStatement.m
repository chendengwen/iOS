//
//  SqlStatement.m
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "SqlStatement.h"
#import "WhereStatement.h"
#import "WhereStatementManager.h"
#import "OrderByStatement.h"
#import "OrderByStatementManager.h"
#import "NSObject+Property.h"

@implementation SqlStatement

#pragma mark -
#pragma mark ==== Get ====
#pragma mark -
+ (NSString *)sqlSelectId:(NSString *)idColumn
                     Name:(NSString *)nameColume
            FromTableName:(NSString *)tableName
                    ByIDs:(NSString *)inIdString
{
    return G_str(@"SELECT [%@], [%@] FROM [%@] WHERE [%@] IN (%@) ",
                  idColumn,
                  nameColume,
                  tableName,
                  idColumn,
                  inIdString);
}

- (void)dealloc
{
    self.sqlValues = nil;
}

- (NSMutableArray *)sqlValues
{
    if(_sqlValues == nil)
    {
        _sqlValues = [[NSMutableArray alloc] init];
    }
    return _sqlValues;
}

- (void)appendWhereSql:(BaseModel *)model
                   sql:(NSMutableString *)sql
              whereKey:(NSArray *)keys
           whereValues:(NSMutableArray *)values
{
    //where语句
    if (keys.count != 0)
    {
        WhereStatementManager *statementManager = [[WhereStatementManager alloc] init];
        
        for (WhereStatement *statement in keys)
        {
            [statementManager.expressions addObject:statement];
        }
        NSString *whereSql = [statementManager whereSql:model];
        if (whereSql.length != 0)
        {
            [sql appendFormat:@" where %@",whereSql];
            [values addObjectsFromArray:statementManager.values];
        }
    }
    
}

- (NSString *)selectSqlfromCloumns:(NSArray *)mColumns
                        tableModel:(BaseModel *)model
                             where:(NSArray *)expressions
                           orderBy:(NSArray *)orderBystatements
                             limit:(NSInteger)mLimit
                            offset:(NSInteger)mOffset
{
    NSMutableString *selectSql = [NSMutableString stringWithString:@"select "];
    
    //查询字段
    if (mColumns.count == 0)
    {
        [selectSql appendString:@"*"];
    }
    else
    {
        for (int i=0; i<mColumns.count; i++)
        {
            if (i>0)
            {
                [selectSql appendString:@","];
            }
            NSString *columnName = [NSString stringWithFormat:@"%@",[mColumns objectAtIndex:i]];
            [selectSql appendString:columnName];
        }
    }
    
    //表名
    NSString *tableName = NSStringFromClass([model class]);
    [selectSql appendFormat:@" from %@",tableName];
    
    NSMutableArray *tempValues = [NSMutableArray array];
    
    //where语句
    [self appendWhereSql:model sql:selectSql whereKey:expressions whereValues:tempValues];
    
    //where语句对应的参数值
    if (self.sqlValues.count != 0)
    {
        [self.sqlValues removeAllObjects];
    }
    [self.sqlValues addObjectsFromArray:tempValues];
    
    //orderBy语句
    if (orderBystatements.count != 0)
    {
        OrderByStatementManager *orderStmtManager = [[OrderByStatementManager alloc] init];
        
        for (OrderByStatement *statement in orderBystatements)
        {
            [orderStmtManager.orderByStatments addObject:statement];
        }
        
        NSString *orderBySql = [orderStmtManager orderBySql];
        if (orderBySql.length != 0)
        {
            [selectSql appendFormat:@" order by %@",orderBySql];
        }
    }
    
    //limit语句
    if (mLimit != NSIntegerMax)
    {
        [selectSql appendFormat:@" limit %ld",(long)mLimit];
    }
    
    //offset语句
    if (mOffset != NSIntegerMax)
    {
        [selectSql appendFormat:@" offset %ld",(long)mOffset];
    }
    
    return selectSql;
}

- (void)appendSetSql:(BaseModel *)model
              setSql:(NSMutableString *)sql
                 key:(NSString *)mKey
           setValues:(NSMutableArray *)values
{
    SEL selector = NSSelectorFromString(mKey);
    
    [sql appendFormat:@"%@ = ?",mKey];
    id propertyValue = nil;
    if ([model respondsToSelector:selector])
    {
        propertyValue = [model valueForKey:mKey];
    }
    if (propertyValue == nil)
    {
        propertyValue = @"";
    }
    [values addObject:propertyValue];
}

- (NSString *)updateTableModel:(BaseModel *)model
                    setColumns:(NSArray *)mColumns
                         where:(NSArray *)expressions
{
    NSMutableString *updateSql = [NSMutableString stringWithString:@"update "];
    
    //表名
    NSString *tableName = NSStringFromClass([model class]);
    [updateSql appendFormat:@"%@ set ",tableName];
    
    NSMutableArray *values = [NSMutableArray array];
    
    if (mColumns == nil)
    {
        NSMutableArray *properties = [NSMutableArray arrayWithArray:[model getPropertyList]];
        NSMutableArray *whereKeys = [NSMutableArray array];
        for (WhereStatement *statement in expressions)
        {
            [whereKeys addObject:statement.key];
        }
        [properties removeObjectsInArray:whereKeys];
        for (int i=0; i<properties.count; i++)
        {
            if (i>0)
            {
                [updateSql appendString:@","];
            }
            NSString *property = [properties objectAtIndex:i];
            [self appendSetSql:model setSql:updateSql key:property setValues:values];
        }
    }
    else
    {
        for (int i=0; i<mColumns.count; i++)
        {
            if (i>0)
            {
                [updateSql appendString:@","];
            }
            
            NSString *columnName = [mColumns objectAtIndex:i];
            [self appendSetSql:model setSql:updateSql key:columnName setValues:values];
        }
    }
    
    //where语句
    [self appendWhereSql:model sql:updateSql whereKey:expressions whereValues:values];
    
    //where语句对应的参数值
    if (self.sqlValues.count != 0)
    {
        [self.sqlValues removeAllObjects];
    }
    [self.sqlValues addObjectsFromArray:values];
    
    return updateSql;
}

- (NSString *)deleteTableModel:(BaseModel *)model
                         where:(NSArray *)expressions
{
    NSMutableString *deleteSql = [NSMutableString stringWithString:@"delete from "];
    
    //表名
    NSString *tableName = NSStringFromClass([model class]);
    [deleteSql appendFormat:@"%@",tableName];
    
    if(expressions == nil) return deleteSql;
    
    NSMutableArray *tempValues = [NSMutableArray array];
    
    //where语句      // 这个操作修改了deleteSql 与 tempValues(model的属性)
    [self appendWhereSql:model sql:deleteSql whereKey:expressions whereValues:tempValues];
    
    //where语句对应的参数值
    if (self.sqlValues.count != 0)
    {
        [self.sqlValues removeAllObjects];
    }
    [self.sqlValues addObjectsFromArray:tempValues];
    
    return deleteSql;
}

- (NSString *)insertTableModel:(BaseModel *)model columns:(NSArray *)mColumns
{
    NSMutableString *insertSql = [NSMutableString stringWithString:@"insert into "];
    
    //model 的类名即是表名
    NSString *tableName = NSStringFromClass([model class]);
    [insertSql appendFormat:@"%@ (",tableName];
    
    for (int i=0; i<mColumns.count; i++)
    {
        if (i>0)
        {
            [insertSql appendString:@","];
        }
        [insertSql appendFormat:@"%@",[mColumns objectAtIndex:i]];
    }
    
    [insertSql appendString:@") values ("];
    
    NSMutableArray *tempValues = [NSMutableArray array];
    for (int i=0; i<mColumns.count; i++)
    {
        NSString *key = [mColumns objectAtIndex:i];
        id value = nil;
        SEL selector = NSSelectorFromString(key);
        if ([model respondsToSelector:selector])
        {
            value = [model valueForKey:key];
        }
        if (value == nil)
        {
            value = @"";
        }
        [tempValues addObject:value];
        
        if (i>0)
        {
            [insertSql appendString:@","];
        }
        [insertSql appendString:@"?"];
        
    }
    
    [insertSql appendString:@")"];
    
    if (self.sqlValues.count != 0)
    {
        [self.sqlValues removeAllObjects];
    }
    [self.sqlValues addObjectsFromArray:tempValues];
    
    return insertSql;
}

@end
