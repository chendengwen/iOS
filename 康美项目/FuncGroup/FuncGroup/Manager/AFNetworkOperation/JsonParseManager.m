//
//  JsonParseManager.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "JsonParseManager.h"
#import "AFError.h"
#import "JSonKit.h"

@implementation JsonParseManager

+ (id)parseJsonObjectWithResponse:(id)responseObject status:(int *)status
                            error:(AFError **)error{
    if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) return nil;
    
    if (status != NULL)
        *status = 0;
    
    NSString *jsonString;
    NSData *jsonData;
    if ([responseObject isMemberOfClass:[NSString class]]) {
        jsonString = responseObject;
        
        if (jsonString == nil || [[jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
            return nil;
        
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
    } else if ([responseObject isMemberOfClass:[NSData class]]) {
        jsonData = responseObject;
    } else if ([responseObject isMemberOfClass:[NSDictionary class]]) {
        jsonData = responseObject;
    }
    
    NSError *jsonError = [[NSError alloc] init];
    NSDictionary *parseObjectDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError != nil) return nil;
    
//    if (![[(NSDictionary *)parseObjectDictionary allKeys] containsObject:kIsSuccess])
//        return nil;
//    
//    if (status != NULL &&
//        [[parseObjectDictionary objectForKey:kIsSuccess] isKindOfClass:[NSNumber class]])
//        *status = [[parseObjectDictionary objectForKey:kIsSuccess] intValue];
//    
//    if (status != NULL && *status != 1)
//    {
//        if (error != NULL)
//            *error = [AFError errorWithCode:AFReturnDataError
//                                errorMessage:[[parseObjectDictionary objectForKey:kMessage] description]];
//    }
    
    if ([parseObjectDictionary isKindOfClass:[NSDictionary class]])
    {
        return parseObjectDictionary;
    }
    
    return nil;
}

+ (id)parserJsonDataWithResponse:(id)response status:(int *)status
{
    return [self parseJsonObjectWithResponse:response status:status error:NULL];
}

+ (NSDictionary *)parseJsonObjectWithResponse:(id)response
{
    return [self parseJsonObjectWithResponse:response status:NULL error:NULL];
}

+ (id)parseJsonObjectWithData:(NSData *)data
{
    if (data == nil)  return nil;
    
    NSError *error = nil;
    id parseObject = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments error:&error];
    if (error != nil)
    {
        return nil;
    }
    
    if ([parseObject isKindOfClass:[NSArray class]]
        || [parseObject isKindOfClass:[NSDictionary class]])
    {
        return parseObject;
    }
    return nil;
}

@end
