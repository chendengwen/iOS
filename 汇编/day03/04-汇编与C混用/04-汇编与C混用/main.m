//
//  main.m
//  04-汇编与C混用
//
//  Created by 小码哥 on 2017/11/11.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sum.h"

//int sum(int a, int b)
//{
//    return a + b;
//}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        NSLog(@"%d", sum(1, 2));
        
        int num1 = 1;
        int num2 = 2;
        int result;
        
        __asm__(
            "addq %%rbx, %%rax"
            : "=a"(result)
            : "a"(num1), "b"(num2)
        );
        
        NSLog(@"%d", result);
    }
    return 0;
}
