//
//  TextCheckManage.m
//  YiYangCloud
//
//  Created by zhong on 2017/5/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "TextCheckManage.h"

@implementation TextCheckManage

+ (instancetype)shareTextCheckManage{
    
    static TextCheckManage *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[TextCheckManage alloc]init];
    });
    return share;
    
}

- (BOOL)CheckTextDecimalText:(UITextField *)textField andRange:(NSRange)range andString:(NSString *)string{
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                if(single == '.')
                {
                    //[self showMyMessage:@"亲，第一个数字不能为小数点!"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                }else{
                    //[self showMyMessage:@"亲，您已经输入过小数点了!"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        //[self showMyMessage:@"亲，您最多输入两位小数!"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //[self showMyMessage:@"亲，您输入的格式不正确!"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;

        }
    }
    else
    {
        return YES;
    }
}
@end
