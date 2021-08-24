//
//  KMRegularExpression.h
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMMatchResult;
@class KMRegularExpression;

/**
 * 匹配表达式，匹配一个URL，返回result
 */
@interface KMRegularExpression : NSRegularExpression

-(KMMatchResult *)matchResultForString:(NSString *)string;
+(KMRegularExpression *)expressionWithPattern:(NSString *)pattern;

@end
