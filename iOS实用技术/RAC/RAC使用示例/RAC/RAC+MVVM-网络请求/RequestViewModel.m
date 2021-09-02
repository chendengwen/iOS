//
//  RequestViewModel.m
//  RAC
//


#import "RequestViewModel.h"
#import <AFNetworking.h>

@implementation RequestViewModel
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // 执行命令
        // 发送请求
        // 创建信号 把发送请求的代码包装到信号里面。
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"帅哥"} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                // 请求成功的时候调用
                NSArray *dictArr = responseObject[@"books"];
                // 遍历books字典数组，将其映射为模型数组
                NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                    return [[NSObject alloc] init];
                }] array];
                [subscriber sendNext:modelArr];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendNext:@[@"error"]];
            }];
            return nil;
        }];
        return signal;// 模型数组
    }];
}

@end
