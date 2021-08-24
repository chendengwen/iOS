//
//  DeviceInteractor.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "GeneralSettingInteractor.h"
#import "AppCacheManager.h"
#import "URLs.h"

@implementation GeneralSettingInteractor

-(void)setdemonstrateOff:(BOOL)off{
    [[AppCacheManager sharedAppCacheManager] setAppCache:@(off) forKey:kDemonstrate];
}

-(BOOL)getdemonstrateOff{
    return [[[AppCacheManager sharedAppCacheManager] cacheForKey:kDemonstrate] boolValue];
}

-(void)setSiteOff:(BOOL)off{
    [[AppCacheManager sharedAppCacheManager] setAppCache:@(off) forKey:kInterface];
}

-(BOOL)getSiteOff{
    return [[[AppCacheManager sharedAppCacheManager] cacheForKey:kInterface] boolValue];
}

-(NSString *)getInterface{
    return [URLs getFullAPIPortType:API_PORT_TYPE_UPLOAD];
//    id interface = [[AppCacheManager sharedAppCacheManager] cacheForKey:kInterface];
//    return interface;
}

-(NSString *)getRecordUrl{
    id recordUrl = [[AppCacheManager sharedAppCacheManager] cacheForKey:kRecordUrl];
    return recordUrl;
}

-(void)setInterface:(NSString *)interface recordUrl:(NSString *)recordUrl{
    [[AppCacheManager sharedAppCacheManager] setAppCache:interface forKey:kInterface];
    [[AppCacheManager sharedAppCacheManager] setAppCache:recordUrl forKey:kRecordUrl];
}

@end
