//
//  RACCombination_.m
//  RAC
//


#import "RACCombination_.h"
#import <ReactiveObjC.h>

@interface RACCombination_ ()
@property (nonatomic,strong)UITextField  *accountF;
@property (nonatomic,strong)UITextField  *pwdF;
@property (nonatomic,strong)UIButton  *loginBtn;
@end

@implementation RACCombination_

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountF = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 200, 40)];
    [self.view addSubview:self.accountF];
    self.accountF.placeholder = @"账号输入";
    self.pwdF = [[UITextField alloc]initWithFrame:CGRectMake(10, 200, 200, 40)];
    [self.view addSubview:self.pwdF];
    self.pwdF.placeholder = @"密码输入";
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 200, 40)];
    [self.view addSubview:self.loginBtn];
    self.loginBtn.backgroundColor = [UIColor redColor];
    
//    [self combineLatest];
    
//    [self zipWith];
    
//    [self merge];
    
//    [self then];
    
    [self concat];
    
    
}

- (void)combineLatest {
    RACSignal *combinSignal = [RACSignal combineLatest:@[self.accountF.rac_textSignal, self.pwdF.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){ //reduce里的参数一定要和combineLatest数组里的一一对应。
        // block: 只要源信号发送内容，就会调用，组合成一个新值。
        NSLog(@"%@ %@", account, pwd);
        return @(account.length && pwd.length);
    }];
    
    // 订阅信号
    //    [combinSignal subscribeNext:^(id x) {
    //        self.loginBtn.enabled = [x boolValue];
    //    }];    // ----这样写有些麻烦，可以直接用RAC宏
    RAC(self.loginBtn, enabled) = combinSignal;
}


- (void)zipWith {
    //zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件。
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    // 压缩成一个信号
    // **-zipWith-**: 当一个界面多个请求的时候，要等所有请求完成才更新UI
    // 等所有信号都发送内容的时候才会调用
    RACSignal *zipSignal = [signalA zipWith:signalB];
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"%@", x); //所有的值都被包装成了元组
    }];
    // 发送信号 交互顺序，元组内元素的顺序不会变，跟发送的顺序无关，而是跟压缩的顺序有关[signalA zipWith:signalB]---先是A后是B
    [signalA sendNext:@1];
    [signalB sendNext:@2];
    
    // <RACTwoTuple: 0x600001432780> (1,2)
}


// 任何一个信号请求完成都会被订阅到
// merge:多个信号合并成一个信号，任何一个信号有新值就会调用
- (void)merge {
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    //组合信号
    RACSignal *mergeSignal = [signalA merge:signalB];
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号---交换位置则数据结果顺序也会交换
    [signalB sendNext:@"下部分"];
    [signalA sendNext:@"上部分"];
    
    //下部分
    //上部分
}


// then --- 使用需求：有两部分数据：想让上部分先进行网络请求但是过滤掉数据，然后进行下部分的，拿到下部分数据
- (void)then {
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"----发送上部分请求---afn");
        
        //模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        });
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // 创建组合信号
    // then;忽略掉第一个信号的所有值
    RACSignal *thenSignal = [signalA then:^RACSignal *{
        // 返回的信号就是要组合的信号
        return signalsB;
    }];
    
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
}


// concat----- 使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行（都可获取值）
- (void)concat {
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"----发送上部分请求---afn");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"上部分数据"];
            [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        });
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"--发送下部分请求--afn");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"下部分数据"];
        });
        return nil;
    }];
    
    // concat:按顺序去链接
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [signalA concat:signalsB];
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}

@end
