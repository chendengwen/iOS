//
//  RAC+MVVM_2.m
//  RAC
//


#import "RAC_MVVM_2.h"
#import "RequestViewModel.h"
#import <ReactiveObjC.h>

@interface RAC_MVVM_2()
//请求视图模型
@property(nonatomic, strong)RequestViewModel *requestVM;
@end

@implementation RAC_MVVM_2

- (RequestViewModel *)requestVM {
    if (!_requestVM) {
        _requestVM = [[RequestViewModel alloc] init];
    }
    return _requestVM;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    RACSignal *signal = [self.requestVM.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}
@end
