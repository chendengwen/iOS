//
//  KMNetAPI.h
//  FuncGroup
//
//  Created by zhong on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMNetAPI : NSObject
+ (instancetype)sharedInstance;
- (void)postWithUrl:(NSString *)url body:(NSData *)body success:(void(^)(NSString *response))success failure:(void(^)(NSError *error))failure;
@end
