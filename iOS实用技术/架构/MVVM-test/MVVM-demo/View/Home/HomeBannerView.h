//
//  HomeBannerView.h
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import <UIKit/UIKit.h>
#import "HomeBannerViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeBannerView : UIScrollView

-(void)bindViewModel;

@end

NS_ASSUME_NONNULL_END
