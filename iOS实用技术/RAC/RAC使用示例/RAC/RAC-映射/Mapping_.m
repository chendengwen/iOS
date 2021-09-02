//
//  Mapping_.m
//  RAC
//


#import "Mapping_.h"
#import <ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>

@interface Mapping_ ()

@end

@implementation Mapping_

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self map];
//    [self flatMap];
//    [self flattenMap2_way1];
//    [self flattenMap2_way2];
    [self flattenMap2_way3];
//    [self flattenMap2_way4];
}

- (void)map {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 绑定信号
    RACSignal *bindSignal = [subject map:^id(id value) {
        // 返回的类型就是你需要映射的值
        return [NSString stringWithFormat:@"映射处理啦:%@", value]; //这里将源信号发送的“123” 前面拼接了ws：
    }];
    // 订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subject sendNext:@"123"];
    
    //映射处理啦:123
}


- (void)flatMap {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 绑定信号
    RACSignal *bindSignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        // block：只要源信号发送内容就会调用
        // value: 就是源信号发送的内容
        // 返回信号用来包装成修改内容的值
        NSString *changevalue = [NSString stringWithFormat:@"改变下值:%@",value];
        return [RACReturnSignal return:changevalue];
    }];
    
    // flattenMap中返回的是什么信号，订阅的就是什么信号(那么，x的值等于value的值，如果我们操纵value的值那么x也会随之而变)
    // 订阅信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 发送数据
    [subject sendNext:@"123"];
    
    //改变下值:123
}


- (void)flattenMap2_way1 {
    // flattenMap 主要用于信号中的信号
    // 创建信号
    RACSubject *signalofSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [signalofSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
    }];
    // 发送信号
    [signalofSignals sendNext:signal];
    [signal sendNext:@"123"];
}

- (void)flattenMap2_way2 {
    // 创建信号
    RACSubject *signalofSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [signalofSignals.switchToLatest  subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    // 发送信号
    [signalofSignals sendNext:signal];
    [signal sendNext:@"123"];
}

- (void)flattenMap2_way3 {
    // flattenMap 主要用于信号中的信号
    // 创建信号
    RACSubject *signalofSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    RACSignal *bignSignal = [signalofSignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value){
        //value:就是源信号发送内容
        return value;
    }];
    [bignSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 发送信号
    [signalofSignals sendNext:signal];
    [signal sendNext:@"123"];
}

//方式4:开发中常用的
- (void)flattenMap2_way4 {
    // flattenMap 主要用于信号中的信号
    // 创建信号
    RACSubject *signalofSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [[signalofSignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [signalofSignals sendNext:signal];
    [signal sendNext:@"123"];
}

@end
