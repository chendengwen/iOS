//
//  NSString + DesEncrypt.h
//  desTest
//
//  Created by mahailin on 13-1-31.
//  Copyright (c) 2013年 mahailin. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kDesKeyString;

/*!
 @brief 用于des的加、解密
 */
@interface NSString (DesEncrypt)

/*!
 @brief     DES加密
 @return    加密后的des string
 */
+ (NSString *)encryptUseDES:(NSString *)encryptString key:(NSString *)keyString;

/*!
 @brief     DES解密
 @return    解密后的string
 */
+ (NSString *)decryptUseDES:(NSString *)decryptString key:(NSString *)keyString;

/*!
 @brief     加密方式 = 拼接所有字符串（注意传参时的顺序） , 字符串装合后再MD5 32位小写加密
 @return    解密后的string
 */
+ (NSString *)decryptUseDDG:(NSString *)string, ...;




/////////////// ************  袋袋金核心加密方式   ************** ///////////////
/**
 加密
 */
+(NSString *)app_EncodeWithData:(NSString *)data key:(NSString *)key expire:(int)expire;

/**
 解密
 */
+(NSString *)app_DecodeWithData:(NSString *)data key:(NSString *)key expire:(int)expire;


@end
