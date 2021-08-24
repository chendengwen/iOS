//
//  KMNetAPI.m
//  FuncGroup
//
//  Created by zhong on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "KMNetAPI.h"

@implementation KMNetAPI
+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)postWithUrl:(NSString *)url body:(NSData *)body success:(void(^)(NSString *response))success failure:(void(^)(NSError *error))failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval= 20;
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSData *data = responseObject;
        NSString *dataStr =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            
            success(dataStr);
            
        } else {
            failure(error);
        }
    }] resume];
}
@end
