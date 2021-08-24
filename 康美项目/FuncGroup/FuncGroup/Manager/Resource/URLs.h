//
//  URLs.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    API_PORT_TYPE_NORMAL,
    API_PORT_TYPE_GET,
    API_PORT_TYPE_UPLOAD,
    API_PORT_TYPE_WEB,
    API_PORT_TYPE_HEALTH_TEST,
    API_PORT_TYPE_IMAGE
} API_PORT_TYPE;

@interface URLs : NSObject


+ (NSString *)getBaseWebUrlString;

+ (NSString *)getBaseImageUrlString;

+(NSString *)getFullAPIPortType:(API_PORT_TYPE)type;

/*!
 @brief     获取登录类API
 @return    logins url string
 */
+ (NSString *)getFullLoginsAPI:(NSString *)segmentAPI;

/*!
 @brief     传入分段路径，返回完整请求路径
 @return    base url string
 */
+(NSString *)getFullReadAPI:(NSString *)segmentAPI;

+(NSString *)urlWithPort:(NSString *)port segmentAPI:(NSString *)segmentAPI;


/*
    get开头 --- 获取信息、资料
    set开头 --- 设置信息、资料
    fuc开头 --- 操作
 */
#define get_verifyCode_regist               @"regist_get"
#define get_verifyCode_forgetPassword       @"forgetPassword"
#define set_forgetPassword                  @"setPassBySms"

#define fuc_loginAuth                       @"loginAuth"
#define fuc_registAuth                      @"auth"
//#define fuc_registAuth                      @"auth"

@end
