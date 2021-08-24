//
//  FeedbackPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "FeedbackPresenter.h"
#import "FeedbackInteractor.h"
#import "AlertButtonView.h"

@interface FeedbackPresenter()
{
    int _feedbackType;  // 反馈的问题类型
    
}

@property (nonatomic,strong) FeedbackInteractor *interactor;

@end

@implementation FeedbackPresenter

-(UIViewController *)getInterface{
    return  [self feedbackViewController];
}

-(FeedBackViewController *)feedbackViewController{
    FeedBackViewController *ctl = [[FeedBackViewController alloc] init];
    self.interface = ctl;
    ctl.presenter = self;
    return ctl;
}

-(FeedbackInteractor *)interactor{
    if (!_interactor) {
        _interactor = [[FeedbackInteractor alloc] init];
    }
    
    return _interactor;
}



#pragma mark === FeedbackVCProtocol
-(void)feedbackTypeClicked{
    
}

-(void)submitButtonClicked:(NSString *)content{
    
}

@end
