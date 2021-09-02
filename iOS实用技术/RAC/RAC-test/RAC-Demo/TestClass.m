//
//  TestClass.m
//  RAC-Demo
//
//  Created by gary on 2021/7/8.
//

#import "TestClass.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation TestClass

//RAC最基本的用法流程
//创建信号、订阅信号、发送信号
-(void)test{
    //1:创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //subscriber 对象不是一个对象
        //3:发送信号
        [subscriber sendNext:@"Cooci"];
            
        //请求网络 失败 error
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:10086 userInfo:@{@"key":@"10086错误"}];
        [subscriber sendError:error];

        // RACDisposable 销毁
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"销毁了");
        }];
    }];

    //2:订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //订阅错误信号
    [signal subscribeError:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];

}
@end
