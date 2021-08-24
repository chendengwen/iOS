//
//  NSString+KMQuery.h
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KMQuery)

+ (NSString *)KMQueryStringWithParameters:(NSDictionary *)parameters;

- (NSDictionary *)KMParametersFromQueryString;

@end
