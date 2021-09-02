//
//  RACReplaySubject_2.m
//  RAC
//


#import "RACReplaySubject_2.h"
#import <ReactiveObjC.h>

@interface RACReplaySubject_2 ()
@property (nonatomic,strong)UIButton  *btn;
@end

@implementation RACReplaySubject_2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 500, 300, 100)];
    [self.btn setTitle:@"返回" forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back{
    [self.subject sendNext:@"返回了哟"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end
