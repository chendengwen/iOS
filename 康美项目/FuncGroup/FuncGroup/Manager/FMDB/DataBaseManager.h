//
//  DataBaseManager.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

/*!
 @class DataBaseManager
 @brief 基础数据库控制器
 */
@interface DataBaseManager : NSObject

/*!
 @brief     基础数据db queue
 */
@property (nonatomic, readonly, strong) FMDatabaseQueue *dbQueue;

/*!
 @brief     BaseDataDBManager单例
 @return    BaseDataDBManager singleton
 */
DEFINE_SINGLETON_FOR_HEADER(DataBaseManager);

/*!
 @brief     resetDBManager单例
 */
+ (void)resetDBManager;

/*!
 @brief     处理数据库错误
 */
- (void)handleDBError;

/*!
 @brief 删除数据库
 *
 */
- (void)removeDBFile:(NSInteger)dbVersion;

/**
 @brief	备份文件目录数据库到备份目录
 *
 *	@return	BOOL
 */
- (BOOL)backupSourceDBFile;

/**
 *	读取备份数据库到文件目录
 *
 *	@return	BOOL
 */
- (BOOL)readSourceDBFileFromBackup;

/**
 *	最近备份时间
 *
 *	@return	NSDate
 */
- (NSDate *)lastBackupDate;

@end
