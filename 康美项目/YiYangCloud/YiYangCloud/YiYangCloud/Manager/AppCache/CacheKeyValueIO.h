//
//  AppCacheInOutProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "idAdditions.h"

@protocol CacheKeyValueInput <NSObject>

-(void)setAppCache:(id)value forKey:(NSString *)key;

-(void)setAppCache:(NSDictionary *)cacheDic;

@end


@protocol CacheKeyValueOutput <NSObject>

-(id<idAdditions>)cacheForKey:(NSString *)key;

-(NSDictionary *)cache;

@end
