//
//  KMRouteMatcher.h
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMRouteRequest.h"

@interface KMRouteMatcher : NSObject

/**
 * URL中://后面的部分，用来匹配和解析参数
 */
@property(nonatomic,copy)NSString * routeExpressionPattern;
/**
 * 原始的URL
 */
@property(nonatomic,copy)NSString * originalRouteExpression;

+(instancetype)matcherWithRouteExpression:(NSString *)expression;
/**
 If a NSURL object matched with routeExpressionPattern,return a WLRRouteRequest object or,otherwise return nil.
 
 @param URL a request url string.
 @param primitiveParameters some primitive parameters like UIImage object and so on.
 @param targetCallBack if complete handle or complete block progress,it will call targetCallBack.
 @return a WLRRouteRequest request object.
 */
-(KMRouteRequest *)createRequestWithURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError *, id responseObject))targetCallBack;


@end
