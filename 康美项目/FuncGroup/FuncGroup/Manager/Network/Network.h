//
//  Network.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject


/*!
 @brief     getCurrentIP
 @return    当前设备的IP
 */
+ (NSString *)getCurrentIP;
/*!
 @brief     getCurrentIP
 @return    当前设备的外网IP
 */
+(NSDictionary *)deviceWANIPAdress;


/*!
 @brief     判断网络是否通畅
 */
+ (BOOL)isNetworkReachable;

/*!
 @brief     判断网络是否WiFi
 */
+ (BOOL)isNetworkReachableViaWiFi;
/*!
 @brief     判断网络是否是2G/3G
 */
+ (BOOL)isNetworkReachableVia2G3G;

/*!
 @brief     开启网络通知
 */
+ (void)startNetworkNotifier;

@end
