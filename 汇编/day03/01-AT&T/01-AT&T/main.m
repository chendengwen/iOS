//
//  main.m
//  01-AT&T
//
//  Created by 小码哥 on 2017/11/11.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

long sum(long a, long b, long c, long d, long e, long f, long g, long h, long i, long j, long k)
{
    return a + b;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int c = sum(LONG_MAX, LONG_MAX, LONG_MAX, LONG_MAX, LONG_MAX, LONG_MAX, LONG_MAX
                    , LONG_MAX, LONG_MAX, LONG_MAX, LONG_MAX
                    );
        NSLog(@"%d", c);
    }
    return 0;
}

/*
 0x100000f32 <+34>: movl   $0xa, -0x14(%rbp)   [rbp-0x14]
 0x100000f39 <+41>: movl   $0xa, -0x18(%rbp)
 0x100000f40 <+48>: movl   -0x14(%rbp), %edi
 0x100000f43 <+51>: addl   -0x18(%rbp), %edi
 */

/* main函数汇编代码-debug
 0x100003ee0 <+0>:   pushq  %rbp
 0x100003ee1 <+1>:   movq   %rsp, %rbp
 0x100003ee4 <+4>:   subq   $0x50, %rsp
 0x100003ee8 <+8>:   movl   $0x0, -0x4(%rbp)
 0x100003eef <+15>:  movl   %edi, -0x8(%rbp)
 0x100003ef2 <+18>:  movq   %rsi, -0x10(%rbp)
 0x100003ef6 <+22>:  callq  0x100003f74               ; symbol stub for: objc_autoreleasePoolPush
 0x100003efb <+27>:  movabsq $0x7fffffffffffffff, %rcx ; imm = 0x7FFFFFFFFFFFFFFF
 0x100003f05 <+37>:  movq   %rcx, %rdi
 0x100003f08 <+40>:  movq   %rcx, %rsi
 0x100003f0b <+43>:  movq   %rcx, %rdx
 0x100003f0e <+46>:  movq   %rcx, -0x20(%rbp)
 0x100003f12 <+50>:  movq   -0x20(%rbp), %r8
 0x100003f16 <+54>:  movq   -0x20(%rbp), %r9
 0x100003f1a <+58>:  movq   -0x20(%rbp), %r10
 0x100003f1e <+62>:  movq   %r10, (%rsp)
 0x100003f22 <+66>:  movq   %r10, 0x8(%rsp)
 0x100003f27 <+71>:  movq   %r10, 0x10(%rsp)
 0x100003f2c <+76>:  movq   %r10, 0x18(%rsp)
 0x100003f31 <+81>:  movq   %r10, 0x20(%rsp)
 0x100003f36 <+86>:  movq   %rax, -0x28(%rbp)
 0x100003f3a <+90>:  callq  0x100003e90               ; sum at main.m:12
 0x100003f3f <+95>:  leaq   0xe2(%rip), %rcx          ; @"%d"
 0x100003f46 <+102>: movl   %eax, -0x14(%rbp)
->  0x100003f49 <+105>: movl   -0x14(%rbp), %esi
 0x100003f4c <+108>: movq   %rcx, %rdi
 0x100003f4f <+111>: movb   $0x0, %al
 0x100003f51 <+113>: callq  0x100003f68               ; symbol stub for: NSLog
 0x100003f56 <+118>: movq   -0x28(%rbp), %rdi
 0x100003f5a <+122>: callq  0x100003f6e               ; symbol stub for: objc_autoreleasePoolPop
 0x100003f5f <+127>: xorl   %eax, %eax
 0x100003f61 <+129>: addq   $0x50, %rsp
 0x100003f65 <+133>: popq   %rbp
 0x100003f66 <+134>: retq
 */
