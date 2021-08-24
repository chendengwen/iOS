//
//  KMRouteRequest.h
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMRouteRequest : NSObject<NSCopying>

@property (nonatomic,copy) NSURL *URL;
/**
 * URL中://后面部分的内容
 */
@property (nonatomic,copy) NSString *routeExpression;

/**
 * URL的查询参数
 */
@property (nonatomic, copy, readonly) NSDictionary *queryParameters;
@property (nonatomic, copy, readonly) NSDictionary *primitiveParams;
@property (nonatomic, copy, readonly) NSDictionary *routeParameters;


@property (nonatomic, strong) NSURL *callbackURL;
@property(nonatomic,copy)void(^targetCallBack)(NSError *error,id responseObject);
@property(nonatomic)BOOL isConsumed;

- (id)objectForKeyedSubscript:(NSString *)key;

-(instancetype)initWithURL:(NSURL *)URL routeExpression:(NSString *)routeExpression routeParameters:(NSDictionary *)routeParameters primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError * error,id responseObject))targetCallBack;

-(instancetype)initWithURL:(NSURL *)URL;

-(void)defaultFinishTargetCallBack;

@end
