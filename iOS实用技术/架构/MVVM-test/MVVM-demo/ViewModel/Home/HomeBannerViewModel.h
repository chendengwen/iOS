//
//  HomeBannerViewModel.h
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import "ViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class HomeBannerViewModel;
@protocol HomeBannerPressDelegate <NSObject>

-(void)homeBannerDidPressed:(HomeBannerViewModel *)model;

@end

@interface HomeBannerViewModel : NSObject<ViewModelProtocol>

//与View显示对应的属性，用于View做KVO观察，当发生变化时 VM 进行处理
@property(nonatomic, assign) NSUInteger view_property_1;

+ (nonnull HomeBannerViewModel *)viewModel;


@end

NS_ASSUME_NONNULL_END
