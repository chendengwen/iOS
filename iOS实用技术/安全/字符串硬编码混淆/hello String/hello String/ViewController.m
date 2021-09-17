//
//  ViewController.m
//  hello String
//
//  Created by guogh_macBookPro on 2017/11/15.
//  Copyright © 2017年 guogh_macBookPro. All rights reserved.
//

#import "ViewController.h"

/*
 *  字符串混淆解密函数，将char[] 形式字符数组和 aa异或运算揭秘
 *  如果没有经过混淆，请关闭宏开关
 */
extern char* decryptConstString(char* string)
{
    char* origin_string = string;
    while(*string) {
        *string ^= 0xAA;
        string++;
    }
    return origin_string;
}


//字符串加密 和 不加密的宏开关
//#define ggh_confusion
#ifdef ggh_confusion
    #define confusion_NSSTRING(string) [NSString stringWithUTF8String:decryptConstString(string)]
    #define confusion_CSTRING(string) decryptConstString(string)
#else
    #define confusion_NSSTRING(string) @string
    #define confusion_CSTRING(string) string
#endif

//代码混淆标识，通过脚本查找到标示替换标识包裹的字符串
//confusion_NSSTRING(string)
//confusion_CSTRING(string)

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *string = confusion_NSSTRING("hello world");
    NSLog(@"%@",string);
    
    //只能混淆英文，暂不支持中文编码
    NSString *string1 = @"只能混淆英文，暂不支持中文编码";
    NSLog(@"%@",string1);
}



@end
