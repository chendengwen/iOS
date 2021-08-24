//
//  EntranceViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOutVCProtocol.h"

@interface EntranceViewController : UIViewController<NavVCProtocol>

@property (nonatomic,strong) id<LoginOutVCProtocol> presenter;

@end
