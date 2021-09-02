//
//  RACCommonUsages.m
//  RAC
//


#import "RACCommonUsages.h"
#import "myRedView.h"
#import <ReactiveObjC.h>

@interface RACCommonUsages ()
@property (nonatomic,assign)int  age;
@end

@implementation RACCommonUsages

- (void)viewDidLoad {
    [super viewDidLoad];
    self.age = 0;
    
    [self RAC_Delegate];
    
    [self RAC_KVO];
    
    [self RAC_ObserveAction];
    
    [self RAC_ObserveTextFieldAndNotification];
    
    [self ARC_MoreSituations];
    
    
}

//控制器要监听红色的view上的button的点击
-(void)RAC_Delegate{
    // 1.RAC替换代理
    // RAC:判断下一个方法有没有调用,如果调用了就会自动发送一个信号给你
    // 只要self调用viewDidLoad就会转换成一个信号
    // 监听_redView有没有调用btnClick,如果调用了就会转换成信号
    myRedView *v = [[myRedView alloc]initWithFrame:CGRectMake(0, 100, 100, 200)];
    [self.view addSubview:v];
    [[v rac_signalForSelector:@selector(btnClick)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"控制器知道,点击了红色的view");
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.age++;
    NSLog(@"点击增的值：%d",self.age);
}

-(void)RAC_KVO{
    // 2.KVO
    // 监听哪个对象的属性改变
    // 方法调用者:就是被监听的对象
    // KeyPath:监听的属性
    // 把监听到内容转换成信号
    [[self rac_valuesForKeyPath:@"age" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"监听的值%@",x);
    }];
}

-(void)RAC_ObserveAction{
    UIButton *btn  =  [UIButton new];
    btn.frame = CGRectMake(20, 400, 40, 40);
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:btn];
    //3.监听事件
    //只要产生UIControlEventTouchUpInside就会转换成信号
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了btn");
    }];
}


-(void)RAC_ObserveTextFieldAndNotification{
    UITextField *textF = [[UITextField alloc]init];
    textF.borderStyle =  UITextBorderStyleRoundedRect;
    textF.frame = CGRectMake(200, 100, 100, 40);
    [self.view addSubview:textF];
    
    //4.监听通知
    // 只要发出这个通知,又会转换成一个信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"弹出键盘");
    }];
    
    // 5.监听文本框文字改变
    // 获取文本框文字改变的信号
    [textF.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

//6.两种（多种）情况都有数据的时候才去做相应的事情
-(void)ARC_MoreSituations{
    // 创建热门商品的信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 处理信号
        NSLog(@"请求热门商品");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 发送数据
            [subscriber sendNext:@"热门商品"];
        });
        return nil;
    }];
    
    // 创建热门商品的信号
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 处理信号
        NSLog(@"请求最新商品");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 发送数据
            [subscriber sendNext:@"最新商品"];
        });
        return nil;
    }];
    
    // RAC:就可以判断两个信号有没有都发出内容
    // SignalsFromArray:监听哪些信号的发出
    // 当signals数组中的所有信号都发送sendNext就会触发方法调用者(self)的selector
    // 注意:selector方法的参数不能乱写,有几个信号就对应几个参数
    // 不需要主动订阅signalA,signalB,方法内部会自动订阅
    [self rac_liftSelector:@selector(updateUIWithHot:new:) withSignalsFromArray:@[signalA,signalB]];
}

// 更新UI
- (void)updateUIWithHot:(NSString *)hot new:(NSString *)new
{
    NSLog(@"更新UI");
}


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end
