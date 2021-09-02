//
//  HomeSubjectsView.h
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import <UIKit/UIKit.h>
#import "HomeSubjectsViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HomeSubjectModel;
@protocol HomeBannerPressDelegate <NSObject>

-(void)homeBannerDidPressed:(HomeSubjectModel *)model;

@end

@interface HomeSubjectsView : UIView

-(void)bindViewModel;

@end

NS_ASSUME_NONNULL_END
