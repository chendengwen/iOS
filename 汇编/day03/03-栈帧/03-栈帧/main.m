//
//  main.m
//  03-栈帧
//
//  Created by 小码哥 on 2017/11/11.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

// 叶子函数:函数内部没有再调用其他函数
// 叶子函数不会减rsp来分配空间给局部变量

void test()
{

}

int sum(int a, int b)
{
    int c = a + b;
    int d = c + 10;
    test();
    return d;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"%d", sum(1, 2));
    }
    return 0;
}

/*
 0x100000ef0 <+0>:  pushq  %rbp
 0x100000ef1 <+1>:  movq   %rsp, %rbp
 
 0x100000ef4 <+4>:  movl   %edi, -0x4(%rbp)
 0x100000ef7 <+7>:  movl   %esi, -0x8(%rbp)
 0x100000efa <+10>: movl   -0x4(%rbp), %esi
 0x100000efd <+13>: addl   -0x8(%rbp), %esi
 0x100000f00 <+16>: movl   %esi, -0xc(%rbp)
 0x100000f03 <+19>: movl   -0xc(%rbp), %esi
 0x100000f06 <+22>: addl   $0xa, %esi
 0x100000f09 <+25>: movl   %esi, -0x10(%rbp)
 0x100000f0c <+28>: movl   -0x10(%rbp), %eax
 
 
 0x100000f0f <+31>: popq   %rbp
 0x100000f10 <+32>: retq
 
 ---------------------------------

 0x100000ef0 <+0>:  pushq  %rbp
 0x100000ef1 <+1>:  movq   %rsp, %rbp
 0x100000ef4 <+4>:  subq   $0x10, %rsp
 
 0x100000ef8 <+8>:  movl   %edi, -0x4(%rbp)
 0x100000efb <+11>: movl   %esi, -0x8(%rbp)
 0x100000efe <+14>: movl   -0x4(%rbp), %esi
 0x100000f01 <+17>: addl   -0x8(%rbp), %esi
 0x100000f04 <+20>: movl   %esi, -0xc(%rbp)
 0x100000f07 <+23>: movl   -0xc(%rbp), %esi
 0x100000f0a <+26>: addl   $0xa, %esi
 0x100000f0d <+29>: movl   %esi, -0x10(%rbp)
 0x100000f10 <+32>: callq  0x100000ee0               ; test at main.m:15
 0x100000f15 <+37>: movl   -0x10(%rbp), %eax
 
 
 0x100000f18 <+40>: addq   $0x10, %rsp
 0x100000f1c <+44>: popq   %rbp
 0x100000f1d <+45>: retq
 
 */
