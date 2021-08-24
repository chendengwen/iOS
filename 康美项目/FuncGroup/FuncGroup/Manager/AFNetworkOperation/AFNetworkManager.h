//
//  AFNetworkOperation.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
#import "AFURLSessionManager.h"
#import "JsonResult.h"
#import "AFError.h"

typedef void(^ResultBlock)(JsonResult *result);

@interface AFNetworkManager : AFURLSessionManager

/**
 *  解析后的返回数据
 */
@property(nonatomic,strong) JsonResult *jsonResult;

/**
 *  超时时间
 */
@property NSTimeInterval timeoutInterval;

/*!
 @property  NSInteger tag
 @brief     用户自定义信息:tag
 */
@property (nonatomic, assign) NSInteger tag;

/*!
 @property  DDGError error
 @brief     错误信息
 */
@property (nonatomic, strong) AFError *error;

/**
 *  序列化控制器
 */
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

DEFINE_SINGLETON_FOR_HEADER(AFNetworkManager)

+ (BOOL)isNetworkReachable;

/*
+(void)GetRequestUrl:(NSString *)urlString parameters:(NSDictionary *)params;

+(void)PostRequestUrl:(NSString *)urlString parameters:(NSDictionary *)params;

+(void)downloadUrl:(NSString *)urlString;

+(void)uploadUrl:(NSString *)urlString data:(NSData *)data;
 */

-(void)GetRequestUrl:(NSString *)urlString parametersArr:(NSArray *)params successBlock:(ResultBlock)completelock failBlock:(ResultBlock)failueBlock;

-(void)PostRequestUrl:(NSString *)urlString parameters:(NSDictionary *)params successBlock:(ResultBlock)completelock failBlock:(ResultBlock)failueBlock;

-(void)uploadUrl:(NSString *)urlString data:(NSData *)data parameters:(NSDictionary *)params successBlock:(ResultBlock)completelock failBlock:(ResultBlock)failueBlock;


/*!
 @brief     将业务http返回的数据转换为json实体
 @param     request 业务操作的请求
 @return    JsonResult的实例
 */
//- (JsonResult *)jsonResultWithRequest:(DDGAFHTTPRequestOperation *)operation;



@end
