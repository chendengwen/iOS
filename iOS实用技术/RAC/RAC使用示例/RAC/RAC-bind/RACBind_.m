//
//  RACBind_.m
//  RAC
//


#import "RACBind_.h"
#import <ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>


@interface RACBind_ ()

@end

@implementation RACBind_

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    // 2.绑定信号
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock{
        // block调用时刻：只要绑定信号订阅就会调用。不做什么事情，
        return ^RACSignal *(id value, BOOL *stop){
            // 一般在这个block中做事 ，发数据的时候会来到这个block。
            // 只要源信号（subject）发送数据，就会调用block
            // block作用：处理源信号内容
            // value:源信号发送的内容，

            
            //这一行也可以注销哟（注销就是123哟）
            value = @3; // 如果在这里把value的值改了，那么订阅绑定信号的值即41行的x就变了
            
            
            NSLog(@"接受到源信号的内容：%@", value);
            //返回信号，不能为nil,如果非要返回空---则empty或 alloc init。
            return [RACReturnSignal return:value]; // 把返回的值包装成信号
        };
    }];
    
    // 3.订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"接收到绑定信号处理完的信号:%@", x);
    }];
    
    // 4.发送信号
    [subject sendNext:@"123"];
}
//接受到源信号的内容：3
//接收到绑定信号处理完的信号:3
@end
