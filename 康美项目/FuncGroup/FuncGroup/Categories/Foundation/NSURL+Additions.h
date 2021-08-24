//
//  NSURL+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Additions)

/*!
 @brief     根据给定的url以及参数字典, 生成NSURL类的实例
 @param     urlString URL字符串
 @param     paramArr 参数字典
 @return    生成NSURL类的实例
 */
+ (id)URLWithString:(NSString *)urlString paramArray:(NSArray *)paramArr;
+ (id)URLWithString:(NSString *)urlString paramDictionary:(NSDictionary *)paramDict;
- (id)initWithString:(NSString *)urlString paramDictionary:(NSDictionary *)paramDict;

/*!
 @brief     根据给定字符串和format参数生成NSURL实例
 @return    NSURL实例
 */
+ (id)URLWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);


@end
