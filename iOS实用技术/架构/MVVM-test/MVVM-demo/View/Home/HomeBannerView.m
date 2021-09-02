//
//  HomeBannerView.m
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import "HomeBannerView.h"

@interface HomeBannerView()

@property(strong) HomeBannerViewModel *viewModel;

@end

@implementation HomeBannerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听viewmodel数据，发生变化时view做出响应
        //可以使用KVO、RAC
        [_viewModel addObserver:self forKeyPath:@"view_property_1" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)bindViewModel{
    _viewModel = [HomeBannerViewModel viewModel];
    [_viewModel fetchData];
}

#pragma KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}

-(void)dealloc{
    [_viewModel removeObserver:self forKeyPath:@"view_property_1"];
}

@end
