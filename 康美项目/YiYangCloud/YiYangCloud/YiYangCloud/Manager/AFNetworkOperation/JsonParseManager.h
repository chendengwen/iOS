//
//  JsonParseManager.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIsSuccess              @"success"
#define kMessage                @"message"

@class AFError;

@interface JsonParseManager : NSObject

/*!
 @brief     解析服务器返回的json数据
 @param     responseObject 响应
 @param     status 返回的状态值
 @param     error  网络请求的错误
 @return    json data包含的数据
 */
+ (id)parseJsonObjectWithResponse:(id)responseObject
                          status:(int *)status
                           error:(AFError **)error;

/*!
 @brief     解析服务器返回的json数据
 @param     responseObject 响应
 @param     status 返回的状态值
 @return    json data包含的数据
 */
+ (id)parserJsonDataWithResponse:(id)responseObject status:(int *)status;

/*!
 @brief     解析服务器返回的json数据
 @param     responseObject 响应
 @return    json data包含的数据
 */
+ (NSDictionary *)parseJsonObjectWithResponse:(id)responseObject;

/*!
 @brief     解析本地的json数据
 @param     data 本地json数据
 @return    json data包含的数据
 */
+ (id)parseJsonObjectWithData:(NSData *)data;

@end
