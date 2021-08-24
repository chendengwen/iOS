//
//  KMRouteMatcher.m
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "KMRouteMatcher.h"

#import "KMRegularExpression.h"
#import "KMRouteRequest.h"
#import "KMMatchResult.h"
@interface KMRouteMatcher()
@property(nonatomic,copy) NSString * scheme;
@property(nonatomic,strong)KMRegularExpression * regexMatcher;
@end
@implementation KMRouteMatcher
+(instancetype)matcherWithRouteExpression:(NSString *)expression{
    return [[self alloc]initWithRouteExpression:expression];
}
-(instancetype)initWithRouteExpression:(NSString *)routeExpression{
    if (![routeExpression length]) {
        return nil;
    }
    if (self = [super init]) {
        /*
         将路由的url匹配表达式进行分割，分割出scheme和后续部分,后续部分形成KMRegularExpression对象，并将url匹配表达式保存在_originalRouteExpression变量中
         */
        NSArray * parts = [routeExpression componentsSeparatedByString:@"://"];
        _scheme = parts.count>1?[parts firstObject]:nil;
        _routeExpressionPattern =[parts lastObject];
        // 生成匹配器
        _regexMatcher = [KMRegularExpression expressionWithPattern:_routeExpressionPattern];
        _originalRouteExpression = routeExpression;
    }
    return self;
}

// 启动路由时调用 
-(KMRouteRequest *)createRequestWithURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void (^)(NSError *, id))targetCallBack{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",URL.host,URL.path];
    if (self.scheme.length && ![self.scheme isEqualToString:URL.scheme]) {
        return nil;
    }
    KMMatchResult * result = [self.regexMatcher matchResultForString:urlString];
    if (!result.isMatched) {
        return nil;
    }
    KMRouteRequest * request = [[KMRouteRequest alloc]initWithURL:URL routeExpression:self.routeExpressionPattern routeParameters:result.paramProperties primitiveParameters:primitiveParameters targetCallBack:targetCallBack];
    return request;
    
}

@end
