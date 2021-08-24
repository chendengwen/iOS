//
//  AFNetworkOperation.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AFNetworkManager.h"
#import "AFNetworkReachabilityManager.h"
#import "JsonParseManager.h"
#import "AFURLSessionManager.h"
#import "ErrorMessage.h"

#import "NSURL+Additions.h"


static AFNetworkReachabilityStatus _networkStatus = AFNetworkReachabilityStatusUnknown;


@implementation AFNetworkManager

DEFINE_SINGLETON_FOR_CLASS(AFNetworkManager)

- (instancetype)init
{
    self = [super initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    if (self) {
        
    }
    return self;
}

+(void)load{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        _networkStatus = status;
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (BOOL)isNetworkReachable{
    return _networkStatus == AFNetworkReachabilityStatusReachableViaWWAN || _networkStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

-(JsonResult *)jsonResult{
//    GASSERT(operation.responseData != nil);
//    if (!operation.responseData) return nil;
    
    NSDictionary *jsonDictionary = [JsonParseManager parseJsonObjectWithResponse:nil];
    
    return [JsonResult instanceWithDict:jsonDictionary];
}


/*
 Security Policy
 
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
 
 */

/*
+(void)GetRequestUrl:(NSString *)urlString parameters:(NSDictionary *)params{
    NSString *URLString = @"http://example.com";
    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
}

+(void)PostRequestUrl:(NSString *)urlString parameters:(NSDictionary *)params{
    NSString *URLString = @"http://example.com";
    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
}

+(void)downloadUrl:(NSString *)urlString{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

}
 
 */

-(void)GetRequestUrl:(NSString *)urlString parametersArr:(NSArray *)params successBlock:(ResultBlock)completelock failBlock:(ResultBlock)failueBlock{
    NSURL *url = [NSURL URLWithString:urlString paramArray:params];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    kWeakSelf(self)
    NSURLSessionDataTask *dataTask = [[AFNetworkManager sharedAFNetworkManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSLog(@"%@ %@", response, responseObject);
        
        [weakself handleData:response responseObject:responseObject error:error successBlock:completelock failBlock:failueBlock];
    }];
    
    [dataTask resume];
}

-(void)PostRequestUrl:(NSString *)urlString parameters:(NSDictionary *)params successBlock:(ResultBlock)completelock failBlock:(ResultBlock)failueBlock{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:nil error:nil];
    
    kWeakSelf(self)
    AFNetworkManager *manager = [AFNetworkManager sharedAFNetworkManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"%@ %@", response, responseObject);
        [weakself handleData:response responseObject:responseObject error:error successBlock:completelock failBlock:failueBlock];
    }];
    [dataTask resume];
}

-(void)uploadUrl:(NSString *)urlString data:(NSData *)data parameters:(NSDictionary *)params successBlock:(ResultBlock)completelock failBlock:(ResultBlock)failueBlock{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                         // [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          dispatch_async(dispatch_get_main_queue(), ^{
                              completelock(responseObject);
                          });
                      }
                  }];
    
    [uploadTask resume];
}

-(void)handleData:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error successBlock:(ResultBlock)completelock failBlock:(ResultBlock)failueBlock{
    if (error) {
        NSLog(@"Error: %@", error);
        if (failueBlock) {
            JsonResult *result = [[JsonResult alloc] init];
            result.msg = [error localizedDescription];
            result.errorCode = error.code;
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failueBlock(result);
            });
        }
    } else {
        if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]])
        {
            JsonResult *result = [[JsonResult alloc] init];
            result.msg = @"返回结果为空";
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failueBlock(result);
            });
            return;
        }
        
        JsonResult *result = [[self class] jsonResultWithresponseObject:responseObject];
        
        if (!result.errorCode){
            NSLog(@"requestFinished -- ParseJSONData success");
            if (result.content)
                [self parseJsonData:result];
            
            if (completelock) {
                dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                    
                    completelock(result);
                });
            }
            
            return;
        }else{
            
            if (result.errorCode > 1000) {
                char *msg = ErrorMessageWithCode((int)result.errorCode);
                msg && (result.msg = [NSString stringWithUTF8String:msg]);
            }
            
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                if (failueBlock) {
                    failueBlock(result);
                }
            });
        }
        
        return;
    }
}


/*!
 @brief     将业务http返回的数据转换为json实体
 @param     responseObject 业务操作的返回的数据
 @return    JsonResult的实例
 */
+ (JsonResult *)jsonResultWithresponseObject:(id)responseObject{
    GASSERT(responseObject != nil);
    if (!responseObject) return nil;
    
//    NSDictionary *jsonDictionary = [JsonParseManager parseJsonObjectWithResponse:responseObject];
    
    return [JsonResult instanceWithDict:[NSDictionary dictionaryWithDictionary:responseObject]];
}

/*!
 @brief    解析JSON数据中的data数据,该方法为abstract类型， 继承类需要重载此方法来实现数据的解析
 */
- (void)parseJsonData:(JsonResult *)jsonResult{
    
//    if ([jsonResult.content isKindOfClass:[NSArray class]] || [jsonResult.content isKindOfClass:[NSDictionary class]])
//    {
//        self.jsonResult = jsonResult;
//    }else{
//        // message 根据返回数据格式来解析并传递，此处未做处理
//        self.error = [AFError errorWithCode:AFUndefinedError errorMessage:@"未知错误"];
//    }
    
}


@end
