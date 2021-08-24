//
//  NSDictionary+Json.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "Json+Utils.h"

CF_INLINE NSString *parseObj2JsonString(id obj);
CF_INLINE NSString *parseObj2JsonString(id obj)
{
    if (obj == nil) return nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:0
                                                         error:&error];
    if (error != nil)
    {
        ///TODO: 记录错误到日志
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@implementation NSArray (JSONSerializing)

- (NSString *)ToJSONString
{
    return parseObj2JsonString(self);
}

@end

@implementation NSDictionary (JSONSerializing)

- (NSString *)ToJSONString
{
    return parseObj2JsonString(self);
}


@end
