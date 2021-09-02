//
//  RACFilter_.m
//  RAC
//


#import "RACFilter_.h"
#import <ReactiveObjC.h>

@interface RACFilter_ ()
@property (nonatomic,strong)UITextField  *textF;
@end

@implementation RACFilter_

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textF = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 500, 60)];
    self.textF.backgroundColor = [UIColor greenColor];
    self.textF.placeholder = @"请输入内容";
    [self.view addSubview:self.textF];
//    [self skip];
//    [self distinctUntilChanged];
//    [self take];
//    [self takeLast];
//    [self takeUntil];
//    [self ignore];
    [self fliter];
}

-(void)skip{
    //skip传入2 跳过前面两个值
    //实际用处： 在实际开发中比如 后台返回的数据前面几个没用，我们想跳跃过去，便可以用skip
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    //3
}

-(void)distinctUntilChanged {
    //如果当前的值跟上一次的值一样，就不会被订阅到
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@2];
    //1 2
}

-(void)take{
    //take:可以屏蔽一些值,取前面几个值---这里take为2 则只拿到前两个值
    RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    //1 2
}

- (void)takeLast {
    //takeLast:和take的用法一样，不过他取的是最后的几个值，如下，则取的是最后两个值
    //注意点:takeLast 一定要调用sendCompleted，告诉他发送完成了，这样才能取到最后的几个值
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendCompleted];
    
    //2 3
}


-(void)takeUntil{
    //takeUntil:---给takeUntil传的是哪个信号，那么当这个信号发送信号或sendCompleted，就不能再接受源信号的内容了（该信号也不发出）
    RACSubject *subject = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    [[subject takeUntil:subject2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject2 sendNext:@3];  //输出：1 2
//    [subject2 sendCompleted]; //输出：1 2
    [subject sendNext:@4];
}


- (void)ignore {
    //ignore:忽略一些值
    //ignoreValues:表示忽略所有的值
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    // 2.忽略一些值
    RACSignal *ignoreSignal = [subject ignore:@2]; // ignoreValues:表示忽略所有的值
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 4.发送数据
    [subject sendNext:@2];
    [subject sendNext:@1];
    [subject sendNext:@2];
    //1  忽略了2
}


-(void)fliter{
    // 只有当文本框的内容长度大于5，才获取文本框里的内容
    [[self.textF.rac_textSignal filter:^BOOL(id value) {
        // value 源信号的内容
        return [value length] > 5;
        // 返回值 就是过滤条件。只有满足这个条件才能获取到内容
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}
@end

