//
//  KMRouter.h
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMRouter : NSObject

/**
 *  URL路由
 */
-(void)handleURL:(NSURL *)url parameters:(NSDictionary *)parama;

-(void)handleURL:(NSURL *)url parameters:(NSDictionary *)parama targetCallBack:(void(^)(NSError *, id responseObject))targetCallBack;


@end
