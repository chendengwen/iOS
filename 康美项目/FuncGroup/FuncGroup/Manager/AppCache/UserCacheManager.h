//
//  UserCacheManager.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheKeyValueIO.h"

#import "UserModel.h"

@interface UserCacheManager : NSObject<CacheKeyValueInput,CacheKeyValueOutput>

@property (nonatomic,strong) UserModel *userModel;

DEFINE_SINGLETON_FOR_HEADER(UserCacheManager)


-(void)clearUserData;

/*
 * 备份用户信息(当前包括：头像)
 */
-(void)backupUserData;

/*
 * 读取用户备份信息(当前包括：头像)
 */
-(void)readUserDataFromBackup;

@end
