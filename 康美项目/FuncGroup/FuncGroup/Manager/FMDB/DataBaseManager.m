//
//  DataBaseManager.m
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DataBaseManager.h"
#import "DocumentPath.h"
#import "DebuggHandler.h"
#import "FMDatabase+Addition.h"
#import "SqlStatement+Table.h"

/**
 *	基础数据库名称
 */
#define BaseDataDBNAME              @"BaseData%ld.sqlite"
#define BaseData_BACKUP_DBNAME      @"BaseData_backup_%ld.sqlite"
#define BaseDataDBNAMESHM           @"BaseData%ld.sqlite-shm"
#define BaseDataDBNAMEWAL           @"BaseData%ld.sqlite-wal"
#define kBaseDataDBVersionKey       @"BaseDataDBVersionKey"

#define kLastBackupDate             @"kLastBackupDate"


//#define kBaseDataDBDateKey @"1970-01-01 00:00:00"
#ifndef kBaseDataDBVersion
#define kBaseDataDBVersion 1
#endif

@interface DataBaseManager ()

/*!
 @property  NSString dbPath
 @brief     数据库完整路径
 */
@property (strong, nonatomic, readonly) NSString *dbPath;

/*!
 @brief     创建数据库，创建前先检查数据库是否存在，考虑修改为带参数是否覆盖
 */
- (void)createDataBase;

/*!
 @brief     判断文件是否存在，不存在时创建
 @return    BOOL DB文件是否存在
 */
- (BOOL)isDBExists;

/*!
 @brief     判断数据库版本是否相同
 @return    相同返回YES, 否则返回NO
 */
- (BOOL)isSameDBVersion;

/*!
 @brief     数据库升级
 @return    升级成功返回YES, 否则返回NO
 */
- (BOOL)updateDataBase;
/*!
 @brief     将数据库从指定低版本升级到高版本
 @param     oldDBVersion 旧版本号
 @param     latestDBVersion 升级的版本号
 */
- (void)updateDBFrom:(NSInteger)oldDBVersion to:(NSInteger)latestDBVersion;

/**
 *	删除旧版本数据库
 *
 *	@param	dbVersion	旧版本号
 */
- (void)removeDBFile:(NSInteger)dbVersion;


@end


@implementation DataBaseManager

@synthesize dbQueue = _dbQueue;

#pragma mark -
#pragma mark ==== Properties ====
#pragma mark -

- (NSString *)dbPath
{
    return [DocumentPath pathForResrouceInDocuments:G_str(BaseDataDBNAME,(long)kBaseDataDBVersion)];
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil)
    {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:self.dbPath];
    }
    return _dbQueue;
}


#pragma mark -
#pragma mark ==== OverridesMethods ====
#pragma mark -

- (id)init
{
    if ((self = [super init]))
    {
        // Document目录下数据库不存在
        if (![self isDBExists])
        {
            [self createDataBase];
        }
        // Document目录下数据库已经存在
        else
        {
            if (![self isSameDBVersion])
            {
                DebugFormatStr(@"current db version = %ld",
                               (long)[[NSUserDefaults standardUserDefaults] integerForKey:kBaseDataDBVersionKey]);
                [self updateDataBase];
                
                DebugFormatStr(@"new db version = %d", kBaseDataDBVersion);
            }
        }
        
    }
    return self;
}

#pragma mark -
#pragma mark ==== ClassMethods ====
#pragma mark -

__strong static DataBaseManager *_dbManager = nil;

DEFINE_SINGLETON_FOR_CLASS(DataBaseManager);

+ (void)resetDBManager
{
    _dbManager = nil;
}

- (void)createDataBase
{
    //判断Resource目录是否有数据库文件，有就copy到Document目录
    if ([self readSourceDBFileFromBackup] == NO)
    {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:[SqlStatement createBPValueModelTable]];
            [db executeUpdate:[SqlStatement createBSValueModelTable]];
            [db executeUpdate:[SqlStatement createTemperatureValueModelTable]];
            [db executeUpdate:[SqlStatement createArchivesValueModelTable]];
            [db executeUpdate:[SqlStatement createDeviceModelTable]];

        }];
    }
    //保存数据库版本号
    [[NSUserDefaults standardUserDefaults] setInteger:kBaseDataDBVersion forKey:kBaseDataDBVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isDBExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.dbPath];
}

- (BOOL)isSameDBVersion
{
    NSInteger dbVersion = [[NSUserDefaults standardUserDefaults] integerForKey:kBaseDataDBVersionKey];
    return dbVersion == kBaseDataDBVersion;
}

- (BOOL)updateDataBase
{
    NSInteger dbVersion = [[NSUserDefaults standardUserDefaults] integerForKey:kBaseDataDBVersionKey];
    
    if (dbVersion == kBaseDataDBVersion) return YES;
    
    [self updateDBFrom:dbVersion to:kBaseDataDBVersion];
    
    [[NSUserDefaults standardUserDefaults] setInteger:kBaseDataDBVersion forKey:kBaseDataDBVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)removeDBFile:(NSInteger)dbVersion
{
    [[NSFileManager defaultManager] removeItemAtPath:
     [DocumentPath pathForResrouceInDocuments:G_str(BaseDataDBNAME,(long)dbVersion)]
                                               error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:
     [DocumentPath pathForResrouceInDocuments:G_str(BaseDataDBNAMESHM,(long)dbVersion)]
                                               error:NULL];
    
    [[NSFileManager defaultManager] removeItemAtPath:
     [DocumentPath pathForResrouceInDocuments:G_str(BaseDataDBNAMEWAL,(long)dbVersion)]
                                               error:NULL];
    
}

/**
 *	复制数据库到备份目录
 *
 *	@return	BOOL
 */
- (BOOL)backupSourceDBFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    NSString *backupDBPath = [DocumentPath pathForResrouceInDocuments:G_str(BaseData_BACKUP_DBNAME,(long)kBaseDataDBVersion)];
    //Document路径中文件存在
    if ([self isDBExists]) {
        if ([fileManager fileExistsAtPath:backupDBPath]){
            BOOL removed = [fileManager removeItemAtPath:backupDBPath error:nil];
            if (removed) {
                NSLog(@"移除成功");
            }
        }
        
        [fileManager copyItemAtPath:self.dbPath toPath:backupDBPath error:&error];
        //复制成功
        if (error == nil) {
            GErrorLog(@"备份基础数据库成功");
            
            // 获得时间对象
            NSDate *date = [NSDate date];
            // 保存当前时间
            [[NSUserDefaults standardUserDefaults] setObject:date forKey:kLastBackupDate];
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)readSourceDBFileFromBackup{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *backupDBPath = [DocumentPath pathForResrouceInDocuments:G_str(BaseData_BACKUP_DBNAME,(long)kBaseDataDBVersion)];
    if ([fileManager fileExistsAtPath:backupDBPath]){
        //Document路径中文件存在 先移除
        if ([self isDBExists]) {
            BOOL removed = [fileManager removeItemAtPath:self.dbPath error:nil];
            if (removed) {
                NSLog(@"移除成功");
                
            }
        }
        
        [fileManager copyItemAtPath:backupDBPath toPath:self.dbPath error:&error];
        if (error == nil) {
            // 移除成功成功后要重新获取Db文件的句柄
            _dbQueue = [[FMDatabaseQueue alloc] initWithPath:self.dbPath];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReadBackup object:nil];
            GErrorLog(@"备份数据库读取成功");
            return YES;
        }
    }

    return NO;
}

- (NSDate *)lastBackupDate
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kLastBackupDate];
    if (date == nil)
    {
        date = Default_date1970;
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:kLastBackupDate];
    }
    
    return date;
}

#pragma mark -
#pragma mark ==== PublicMethods ====
#pragma mark -

- (void)handleDBError
{
    GErrorLog(@"db operation error occurred.");
}


#pragma mark -
#pragma mark ==== UpdateMethods ====
#pragma mark -
- (void)updateDBFrom:(NSInteger)oldDBVersion to:(NSInteger)latestDBVersion
{
    if (oldDBVersion == latestDBVersion) return;
    //删除旧的数据库
    [self removeDBFile:oldDBVersion];
    
    //创建新数据库
    [self createDataBase];
}

@end
