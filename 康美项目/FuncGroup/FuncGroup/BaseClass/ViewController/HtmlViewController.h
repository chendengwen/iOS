//
//  HtmlViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalWebView.h"

@interface HtmlViewController : UIViewController<JSDelegate>

@property (nonatomic,copy) NSString *fileName;

@end
