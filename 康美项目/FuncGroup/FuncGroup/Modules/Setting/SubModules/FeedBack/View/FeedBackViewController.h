//
//  FeedBackViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedbackVCProtocol <NSObject>

-(void)feedbackTypeClicked;

-(void)submitButtonClicked:(NSString *)content;

@end

@interface FeedBackViewController : UIViewController

@property (nonatomic,strong) id<FeedbackVCProtocol> presenter;

@end
