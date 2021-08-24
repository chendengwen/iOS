//
//  UserCacheManager.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "UserCacheManager.h"

@implementation UserCacheManager

DEFINE_SINGLETON_FOR_CLASS(UserCacheManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userModel = self.userModel;
    }
    return self;
}

#pragma mark -
#pragma mark ==== userModel ====
#pragma mark -
- (UserModel *)userModel
{
    if (!_userModel)
    {
        _userModel = (UserModel *)[UserModel valuesFromUnarchiveing];
        
        if (!_userModel || ![_userModel isKindOfClass:[BaseCodingModel class]]) {
            _userModel = [[UserModel alloc] init];
        }
    } 
    return _userModel;
}

#pragma Function
-(void)clearUserData{
    [self clearMemoryData];
    [self clearDiskData];
}

-(void)clearMemoryData{
    self.userModel = nil;
}

-(void)clearDiskData{
//    [NSKeyedArchiver archiveRootObject:nil toFile:AccountFile];
    [UserModel clearCodingDataFilePath:nil];
}

-(void)backupUserData{
    
}

-(void)readUserDataFromBackup{
    
}

#pragma mark === setter
#pragma parm === UserCacheInput
-(void)setAppCache:(id)value forKey:(NSString *)key{
    [self.userModel setValue:value forKey:key];
}

-(void)setAppCache:(NSDictionary *)cacheDic{
    [self.userModel setValuesForKeysWithDictionary:cacheDic];
}

-(id<idAdditions>)cacheForKey:(NSString *)key{
    id value = [self.userModel valueForKey:key];
    if ([value isKindOfClass:[NSNull class]] || value == 0x0) {
        return nil;
    }
    return value;
}

-(NSDictionary *)cache{
    return nil;
}

@end
