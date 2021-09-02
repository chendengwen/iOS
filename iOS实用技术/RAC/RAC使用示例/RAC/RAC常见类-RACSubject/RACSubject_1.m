//
//  RACSubject.m
//  RAC
//


#import "RACSubject_1.h"
#import <ReactiveObjC.h>
#import "RACSubject_2.h"

@interface RACSubject_1 ()
@property (nonatomic,strong)UIButton  *btn;
@end

@implementation RACSubject_1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 500, 300, 100)];
    [self.btn setTitle:@"开始" forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
}

-(void)jump{
    RACSubject_2 *vc = [[RACSubject_2 alloc]init];
    vc.subject =[RACSubject subject];
    @weakify(self);//防止循环引用
    [vc.subject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.btn setTitle:x forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

@end
