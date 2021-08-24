//
//  SqlStatement+Table.h
//  FuncGroup
//
//  Created by gary on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "SqlStatement.h"

@interface SqlStatement (Table)

/*!
 @brief     create table VJQUser
 @return	NSString 创建表的sql语句
 */
+ (NSString *)createBPValueModelTable;
+ (NSString *)createBSValueModelTable;
+ (NSString *)createTemperatureValueModelTable;
+ (NSString *)createDeviceModelTable;
+ (NSString *)createArchivesValueModelTable;


@end
