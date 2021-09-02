//
//  RACReplaySubject_1.m
//  RAC
//


#import "RACReplaySubject_1.h"
#import <ReactiveObjC.h>
#import "RACReplaySubject_2.h"


@interface RACReplaySubject_1 ()
@property (nonatomic,strong)UIButton  *btn;
@property (nonatomic,strong)RACReplaySubject  *subject;
@end

@implementation RACReplaySubject_1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 500, 300, 100)];
    [self.btn setTitle:@"开始" forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    
    // 1.创建信号
    RACReplaySubject *subject = [RACReplaySubject subject];
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
    NSLog(@"第二个订阅者%@",x);
    }];
    // 3.发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    self.subject = subject;

}

-(void)jump{
    RACReplaySubject_2 *vc = [[RACReplaySubject_2 alloc]init];
    vc.subject =  self.subject;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end

