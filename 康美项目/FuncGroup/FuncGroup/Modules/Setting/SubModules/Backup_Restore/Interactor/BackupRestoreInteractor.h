//
//  BackupRestoreInteractor.h
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BackupRestoreOperProtocol <NSObject>

-(void)backupSuccessed;

-(void)backupFailed;

-(void)restoreSuccessed;

-(void)restoreFailed;

@end

@interface BackupRestoreInteractor : NSObject

@property (nonatomic,weak) UIViewController<BackupRestoreOperProtocol> *handler;

DEFINE_SINGLETON_FOR_HEADER(BackupRestoreInteractor)

@property (nonatomic,weak) id<BackupRestoreOperProtocol> delegate;

/*
 * 备份
 */
-(void)backupLocalData;

/*
 * 还原
 */
-(void)restoreLocalData;

- (NSDate *)lastBackupDate;

@end
