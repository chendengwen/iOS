//
//  RAC_MVVM.m
//  RAC
//


#import "RAC_MVVM.h"
#import <ReactiveObjC.h>
#import <ReactiveObjC/RACSubscriptingAssignmentTrampoline.h>
#import "loginViewModel.h"

@interface RAC_MVVM ()
@property (nonatomic,strong)UITextField  *accountF;
@property (nonatomic,strong)UITextField  *pwdF;
@property (nonatomic,strong)UIButton  *loginBtn;
@property(nonatomic, strong)loginViewModel *loginVM;
@end

@implementation RAC_MVVM

- (loginViewModel *)loginVM {
    if (!_loginVM) {
        _loginVM = [[loginViewModel alloc] init];
    }
    return _loginVM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountF = [[UITextField alloc]initWithFrame:CGRectMake(10, 200, 200, 40)];
    self.accountF.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:self.accountF];
    
    self.accountF.placeholder = @"账号输入";
    self.pwdF = [[UITextField alloc]initWithFrame:CGRectMake(10, 250, 200, 40)];
    [self.view addSubview:self.pwdF];
    self.pwdF.borderStyle =  UITextBorderStyleRoundedRect;
    self.pwdF.placeholder = @"密码输入";
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 200, 40)];
    [self.view addSubview:self.loginBtn];
    
    [self bindViewModel];
    [self loginEvent];
}

- (void)bindViewModel {
    // 1.给视图模型的账号和密码绑定信号
    RAC(self.loginVM, account) = self.accountF.rac_textSignal;
    RAC(self.loginVM, pwd) = self.pwdF.rac_textSignal;
    
//    RACSubscriptingAssignmentTrampoline *subscript = [[RACSubscriptingAssignmentTrampoline alloc] initWithTarget:self.loginVM nilValue:nil];
//    subscript[@"pwd"] = self.pwdF.rac_textSignal;
    //作用相同
//    [subscript setObject:self.pwdF.rac_textSignal forKeyedSubscript:@"pwd"];
    
    /* 实现这些方法后就可以使用下标语法取值和赋值 ：subscript[@"pwd"]
     - (id)objectAtIndexedSubscript:(NSUInteger)idx;
     - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
     - (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
     - (id)objectForKeyedSubscript:(id)key;
     */
}


- (void)loginEvent {
     @weakify(self);
    // 1.处理文本框业务逻辑--- 设置按钮是否能点击
    RAC(self.loginBtn, enabled) = self.loginVM.loginEnableSignal;
    
    [RACObserve(self.loginBtn, enabled) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x boolValue]==1){
            [self.loginBtn setTitle:@"可以点" forState:UIControlStateNormal];
            [self.loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.loginBtn setBackgroundColor:[UIColor greenColor]];
        }else{
            [self.loginBtn setTitle:@"不可以点" forState:UIControlStateNormal];
            [self.loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.loginBtn setBackgroundColor:[UIColor greenColor]];
        }
    }];
    // 2.监听登录按钮点击
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"点击登录按钮");
        // 处理登录事件
        [self.loginVM.loginCommand execute:nil];
    }];

}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end
