//
//  BackupRestoreInteractor.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BackupRestoreInteractor.h"
#import "DataBaseManager.h"
#import "UserCacheManager.h"

@implementation BackupRestoreInteractor

DEFINE_SINGLETON_FOR_CLASS(BackupRestoreInteractor)

-(void)backupLocalData{
    BOOL success = [[DataBaseManager sharedDataBaseManager] backupSourceDBFile];
    [[UserCacheManager sharedUserCacheManager] backupUserData];
    
    if (success) {
         [self.delegate backupSuccessed];
    } else{
         [self.delegate backupFailed];
    }
   
}

-(void)restoreLocalData{
    BOOL success = [[DataBaseManager sharedDataBaseManager] readSourceDBFileFromBackup];
    [[UserCacheManager sharedUserCacheManager] readUserDataFromBackup];
    
    if (success) {
        [self.delegate restoreSuccessed];
    } else{
        [self.delegate restoreFailed];
    }
}

- (NSDate *)lastBackupDate{
    return [[DataBaseManager sharedDataBaseManager] lastBackupDate];
}

@end
