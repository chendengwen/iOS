//
//  AppCacheManager.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AppCacheManager.h"
#import "CacheModel.h"

@interface AppCacheManager()

@property (nonatomic,strong) CacheModel *cacheModel;

@end

@implementation AppCacheManager

DEFINE_SINGLETON_FOR_CLASS(AppCacheManager)

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"self.cacheModel.currentID"];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _cacheModel = self.cacheModel;
        
        if ([self cacheForKey:kPsdOff] == nil) {
            [self setAppCache:@(YES) forKey:kPsdOff];
        }
        
        [self addObserver:self forKeyPath:@"cacheModel.currentID" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self; 
}

#pragma mark -
#pragma mark ==== cacheModel ====
#pragma mark -
- (CacheModel *)cacheModel{
    if (!_cacheModel)
    {
        _cacheModel = (CacheModel *)[CacheModel valuesFromUnarchiveing];
        
        if (!_cacheModel || ![_cacheModel isKindOfClass:[BaseCodingModel class]]) {
            _cacheModel = [[CacheModel alloc] init];
        }
    }
    return _cacheModel;
}

#pragma parm === AppCacheOutput
-(id<idAdditions>)cacheForKey:(NSString *)key{
    id value = [self.cacheModel valueForKey:key];
    if ([value isKindOfClass:[NSNull class]] || value == 0x0) {
        return nil;
    }
    return value;
}

-(NSDictionary *)cache{
    return nil;
}

#pragma parm === AppCacheInput
-(void)setAppCache:(id)value forKey:(NSString *)key{
    [self.cacheModel setValue:value forKey:key];
}

-(void)setAppCache:(NSDictionary *)cacheDic{
    [self.cacheModel setValuesForKeysWithDictionary:cacheDic];
}


#pragma mark === Observe
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserSwith object:nil];
}

@end
