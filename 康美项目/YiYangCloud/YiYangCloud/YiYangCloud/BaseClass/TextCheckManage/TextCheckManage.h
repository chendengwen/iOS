//
//  TextCheckManage.h
//  YiYangCloud
//
//  Created by zhong on 2017/5/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextCheckManage : NSObject
+ (instancetype)shareTextCheckManage;
- (BOOL)CheckTextDecimalText:(UITextField *)textField andRange:(NSRange)range andString:(NSString *)string;

@end
