//
//  HomeBannerViewModel.m
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import "HomeBannerViewModel.h"

@interface HomeBannerViewModel()
@property(strong) HomeBannersModel *bannersModel;
@end

@implementation HomeBannerViewModel
//@synthesize model;

- (NSUInteger)view_property_1{
    return _bannersModel.models.count;
}

+ (nonnull HomeBannerViewModel *)viewModel{
    return [[HomeBannerViewModel alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bannersModel = [[HomeBannersModel alloc] init];
    }
    return self;
}

-(void)fetchData{
    __weak typeof(self) weakSelf = self;
    [_bannersModel fetchData:@"" params:nil success:^(id data) {
        if (data != nil) {
            weakSelf.bannersModel.models = @[];
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
