//
//  Demo.m
//  RAC
//


#import "Demo.h"
#import <ReactiveObjC.h>

@interface Demo ()
@property (nonatomic,assign)int time;
@property (nonatomic,strong) RACDisposable *disposable;
@end

@implementation Demo

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 60)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [btn  addTarget:self action:@selector(reSendCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)reSendCode:(UIButton*)sender{
    self.time = 15;
    @weakify(self);
    self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]]  subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self);
        self.time--;
        NSString *btnText = self.time >0 ? [NSString stringWithFormat:@"%ds",self.time]:@"发送验证码";
        [sender setTitle:btnText forState:(UIControlStateNormal)];
        if(self.time>0){
            sender.enabled = NO;
        }else{
            sender.enabled = YES;
            [self.disposable dispose];//在我们取消订阅的那一刹那，帮我们打断了循环引用
        }
    }];
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end
