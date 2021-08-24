//
//  AppCacheManager.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheKeyValueIO.h"
#import "Defaulter.h"

typedef enum:int {
    AppStateFirstLoad,      // 首次打开
    AppStateUnlogin,        // 首次未登录
    AppStateLogined         // 首次已登录
}AppState;

@class UserCacheManager;

@interface AppCacheManager : NSObject<CacheKeyValueInput,CacheKeyValueOutput>

@property (nonatomic, weak)  id<CacheKeyValueOutput> output;
@property (nonatomic, weak)  id<CacheKeyValueInput>  input;

DEFINE_SINGLETON_FOR_HEADER(AppCacheManager)

@end
