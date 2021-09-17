//
//  WLRRouteMatcher.m
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import "WLRRouteMatcher.h"
#import "WLRRegularExpression.h"
#import "WLRRouteRequest.h"
#import "WLRMatchResult.h"
@interface WLRRouteMatcher()
@property(nonatomic,copy) NSString * scheme;
@property(nonatomic,strong)WLRRegularExpression * regexMatcher;
@end
@implementation WLRRouteMatcher
+(instancetype)matcherWithRouteExpression:(NSString *)expression{
    return [[self alloc]initWithRouteExpression:expression];
}
-(instancetype)initWithRouteExpression:(NSString *)routeExpression{
    if (![routeExpression length]) {
        return nil;
    }
    if (self = [super init]) {
        /*
            将路由的url匹配表达式进行分割，分割出scheme和后续部分,后续部分形成WLRRegularExpression对象，并将url匹配表达式保存在_originalRouteExpression变量中
         */
        NSArray * parts = [routeExpression componentsSeparatedByString:@"://"];
        _scheme = parts.count>1?[parts firstObject]:nil;
        _routeExpressionPattern =[parts lastObject];
        _regexMatcher = [WLRRegularExpression expressionWithPattern:_routeExpressionPattern];
        _originalRouteExpression = routeExpression;
    }
    return self;
}
-(WLRRouteRequest *)createRequestWithURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void (^)(NSError *, id))targetCallBack{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",URL.host,URL.path];
    if (self.scheme.length && ![self.scheme isEqualToString:URL.scheme]) {
        return nil;
    }
    WLRMatchResult * result = [self.regexMatcher matchResultForString:urlString];
    if (!result.isMatch) {
        return nil;
    }
    WLRRouteRequest * request = [[WLRRouteRequest alloc]initWithURL:URL routeExpression:self.routeExpressionPattern routeParameters:result.paramProperties primitiveParameters:primitiveParameters targetCallBack:targetCallBack];
    return request;
    
}
@end
