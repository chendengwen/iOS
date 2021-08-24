//
//  NSDictionary+Json.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSONSerializing)
/**
 *	数组转为JSON字符串
 *
 *	@return	NSString
 */
- (NSString *)ToJSONString;
@end


@interface NSDictionary (JSONSerializing)
/**
 *	字典转为JSON字符串
 *
 *	@return	NSString
 */
- (NSString *)ToJSONString;
@end

