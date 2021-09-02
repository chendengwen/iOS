//
//  RACDisposable_.m
//  RAC
//


#import "RACDisposable_.h"
#import <ReactiveObjC.h>

@interface RACDisposable_ ()
@property (nonatomic,strong)id<RACSubscriber>  subscriber;
@end

@implementation RACDisposable_

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建信号（冷信号）
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        [subscriber  sendNext:@"1"];
        
        //n保存订阅者，不会t让他自动消失
        self->_subscriber = subscriber;
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅啦");
        }];
    }];
    
    //订阅信号（热信号）
    RACDisposable  *disposable = [signal subscribeNext:^(id  _Nullable x) {
        //信号接收处
        NSLog(@"%@",x);
    }];
    
    //默认一个信号发送完毕会自动取消订阅的
    //因为是用属性 来保存了
    //手动取消订阅
    [disposable dispose];
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end
