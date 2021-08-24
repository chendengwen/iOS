//
//  URLs.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "URLs.h"

// 接口URL
static NSString *const kBaseURL = @"http://watch.medquotient.com:";
static NSString *const kBaseImageURL = @"viewFile/client?imageName=";

static NSString *const kBaseSegmentFilePath = @"/";

#if Debug
#define Port_upload         @"7000"
#define Port_web            @"8060"
#define Port_HealthTest     @"8091"
#define Port_login          @"7000"
#define Port_image          @"7000"
#else
#define Port_upload         @"8999"
#define Port_web            @"8060"
#define Port_HealthTest     @"8091"
#define Port_login          @"8880"
#define Port_image          @"8880"
#endif

@implementation URLs

+ (NSString *)getBaseUrlString{
#if Debug
    return @"http://10.2.20.243:";
#else
    return kBaseURL;
#endif
}

+(NSString *)getFullAPIPortType:(API_PORT_TYPE)type{
    NSString *port = nil;
    switch (type) {
        case API_PORT_TYPE_NORMAL:
            port = Port_login;
            break;
        case API_PORT_TYPE_GET:
            port = Port_login;
            break;
        case API_PORT_TYPE_UPLOAD:
            port = Port_upload;
            break;
        case API_PORT_TYPE_WEB:
            port = Port_web;
            break;
        case API_PORT_TYPE_HEALTH_TEST:
            port = Port_HealthTest;
            break;
        case API_PORT_TYPE_IMAGE:
            port = Port_image;
            break;
        default:
            break;
    }
    return [URLs getBaseUrlStringWithPort:port];
}

+ (NSString *)getBaseUrlStringWithPort:(NSString *)port{
    return [[URLs getBaseUrlString] stringByAppendingString:port];
}

+ (NSString *)getBaseWebUrlString{
    return [URLs getFullAPIPortType:API_PORT_TYPE_WEB];
}

+ (NSString *)getBaseImageUrlString{
    return [URLs getFullAPIPortType:API_PORT_TYPE_IMAGE];
}


//////////////////////////////////////////////////////////////////////////////////////////
/*!
 @brief     获取读取、验证类API
 */
+ (NSString *)getFullReadAPI:(NSString *)segmentAPI{
    return [[URLs getFullAPIPortType:API_PORT_TYPE_UPLOAD] stringByAppendingFormat:@"%@%@",kBaseSegmentFilePath, segmentAPI];
}

/*!
 @brief     获取登录类API
 */
+ (NSString *)getFullLoginsAPI:(NSString *)segmentAPI{
    return [[URLs getFullAPIPortType:API_PORT_TYPE_GET] stringByAppendingFormat:@"%@%@",kBaseSegmentFilePath, segmentAPI];
}

/*!
 @brief     未定义端口的API
 */
+(NSString *)urlWithPort:(NSString *)port segmentAPI:(NSString *)segmentAPI{
    return [[URLs getBaseUrlStringWithPort:port] stringByAppendingString:segmentAPI];
}

@end
