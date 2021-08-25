//
//  main.m
//  02-反汇编
//
//  Created by 小码哥 on 2017/11/11.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

//int sum(int a, int b)
//{
//    return a + b;
//}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int a = 4;
//        if (a == 1) {
//            NSLog(@"1");
//        } else if (a == 2) {
//            NSLog(@"2");
//        } else if (a == 3) {
//            NSLog(@"3");
//        } else if (a == 4) {
//            NSLog(@"4");
//        } else if (a == 5) {
//            NSLog(@"5");
//        } else {
//            NSLog(@"else");
//        }
        
        switch (a) {
            case 1:
                NSLog(@"1");
                break;
            case 2:
                NSLog(@"2");
                break;
            case 3:
                NSLog(@"3");
                break;
            case 100:
                NSLog(@"4");
                break;
            case 105:
                NSLog(@"5");
                break;
            default:
                NSLog(@"else");
                break;
        }
        
        
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"1");
//        }
        
        
//        int a = 10;
//        if (a > 10) {
//            NSLog(@"1");
//        } else if (a > 5) {
//            NSLog(@"2");
//        } else if (a > 1) {
//            NSLog(@"3");
//        } else {
//            NSLog(@"4");
//        }
        
        
//        NSLog(@"%d", sum(1, 2));
        
//        int a = 1;
//        int c = a++ + a++ + a++;
//        NSLog(@"%d", c);
        
        
        // sizeof不是函数,是编译器特性
        // NSLog(@"%ld", sizeof(long));
        
//        int a = 1;
////        int c = a++ + a++ + a++;
//        int c = ++a + a++ + ++a;
//        NSLog(@"%d", c);
    }
    return 0;
}
/*
 rcx是变量和最小条件的差值
 
 0x100000ea9 <+73>:  movslq (%rax,%rcx,4), %rdx
    
    mov rdx, [0x40000 + 9 * 4]
 
 0x100000ead <+77>:  addq   %rax, %rdx
 0x100000eb0 <+80>:  jmpq   *%rdx
 */

/*
 for (int i = 0; i < 5; i++) {
    NSLog(@"1");
 }
 
 debug
 0x100000f2b <+27>: movl   $0x0, -0x14(%rbp)
 0x100000f32 <+34>: movq   %rax, -0x20(%rbp)
 0x100000f36 <+38>: cmpl   $0x5, -0x14(%rbp)
 0x100000f3a <+42>: jge    0x100000f5f               ; <+79> at main.m:50
 0x100000f40 <+48>: leaq   0xe1(%rip), %rax          ; @"'1'"
 0x100000f47 <+55>: movq   %rax, %rdi
 0x100000f4a <+58>: movb   $0x0, %al
 0x100000f4c <+60>: callq  0x100000f70               ; symbol stub for: NSLog
 0x100000f51 <+65>: movl   -0x14(%rbp), %eax
 0x100000f54 <+68>: addl   $0x1, %eax
 0x100000f57 <+71>: movl   %eax, -0x14(%rbp)
 
 release
 0x100000f47 <+18>: movl   $0x5, %ebx
 0x100000f4c <+23>: leaq   0xd5(%rip), %r15          ; @"'1'"
 0x100000f53 <+30>: xorl   %eax, %eax
 0x100000f55 <+32>: movq   %r15, %rdi
 0x100000f58 <+35>: callq  0x100000f76               ; symbol stub for: NSLog
 ->  0x100000f5d <+40>: decl   %ebx
 0x100000f5f <+42>: jne    0x100000f53               ; <+30> at main.m:20
 */

/*
 NSLog(@"%d", sum(1, 2));
 
 debug
 0x100000f3b <+27>: movl   $0x1, %edi
 0x100000f40 <+32>: movl   $0x2, %esi
 ->  0x100000f45 <+37>: movq   %rax, -0x18(%rbp)
 0x100000f49 <+41>: callq  0x100000f00               ; sum at main.m:12
 0x100000f4e <+46>: leaq   0xd3(%rip), %rcx          ; @"%d"
 0x100000f55 <+53>: movq   %rcx, %rdi
 0x100000f58 <+56>: movl   %eax, %esi
 0x100000f5a <+58>: movb   $0x0, %al
 0x100000f5c <+60>: callq  0x100000f72               ; symbol stub for: NSLog
 
 release
 0x100000f43 <+11>: movq   %rax, %rbx
 ->  0x100000f46 <+14>: leaq   0xdb(%rip), %rdi          ; @"%d"
 0x100000f4d <+21>: movl   $0x3, %esi
 0x100000f52 <+26>: xorl   %eax, %eax
 0x100000f54 <+28>: callq  0x100000f6a               ; symbol stub for: NSLog
 */

/*
        int a = 1;
        int c = a++ + a++ + a++;
        NSLog(@"%d", c);
 
 debug
 0x100000f0b <+27>:  leaq   0x116(%rip), %rsi         ; @"%d"
 0x100000f12 <+34>:  movl   $0x1, -0x14(%rbp)
 0x100000f19 <+41>:  movl   -0x14(%rbp), %edi
 0x100000f1c <+44>:  movl   %edi, %ecx
 0x100000f1e <+46>:  addl   $0x1, %ecx
 0x100000f21 <+49>:  movl   %ecx, -0x14(%rbp)
 0x100000f24 <+52>:  movl   -0x14(%rbp), %ecx
 0x100000f27 <+55>:  movl   %ecx, %edx
 0x100000f29 <+57>:  addl   $0x1, %edx
 0x100000f2c <+60>:  movl   %edx, -0x14(%rbp)
 0x100000f2f <+63>:  addl   %ecx, %edi
 0x100000f31 <+65>:  movl   -0x14(%rbp), %ecx
 0x100000f34 <+68>:  movl   %ecx, %edx
 0x100000f36 <+70>:  addl   $0x1, %edx
 0x100000f39 <+73>:  movl   %edx, -0x14(%rbp)
 0x100000f3c <+76>:  addl   %ecx, %edi
 0x100000f3e <+78>:  movl   %edi, -0x18(%rbp)
 ->  0x100000f41 <+81>:  movl   -0x18(%rbp), %ecx
 0x100000f44 <+84>:  movq   %rsi, %rdi
 0x100000f47 <+87>:  movl   %ecx, %esi
 0x100000f49 <+89>:  movq   %rax, -0x20(%rbp)
 0x100000f4d <+93>:  movb   $0x0, %al
 0x100000f4f <+95>:  callq  0x100000f66               ; symbol stub for: NSLog

 release
 0x100000f4b <+11>: movq   %rax, %rbx
 ->  0x100000f4e <+14>: leaq   0xd3(%rip), %rdi          ; @"%d"
 0x100000f55 <+21>: movl   $0x6, %esi
 0x100000f5a <+26>: xorl   %eax, %eax
 0x100000f5c <+28>: callq  0x100000f72               ; symbol stub for: NSLog
 */

/*
 -0x14(%rbp) -> 局部变量a
 -0x18(%rbp) -> 局部变量c
 
 int a = 1;
 int c = a++ + a++ + a++;
 
 %edx的值 == 6
 %r8d的值 == 3
 a的值 = 4
 
 0x100000f11 <+65>:  movl   $0x1, 局部变量a
 0x100000f18 <+72>:  movl   局部变量a, %edx
 0x100000f1b <+75>:  movl   %edx, %r8d
 
 0x100000f1e <+78>:  addl   $0x1, %r8d
 0x100000f22 <+82>:  movl   %r8d, 局部变量a
 
 0x100000f26 <+86>:  movl   局部变量a, %r8d
 
 
 0x100000f2a <+90>:  movl   %r8d, %r9d
 0x100000f2d <+93>:  addl   $0x1, %r9d
 0x100000f31 <+97>:  movl   %r9d, 局部变量a
 
 
 0x100000f35 <+101>: addl   %r8d, %edx
 
 0x100000f38 <+104>: movl   局部变量a, %r8d
 
 0x100000f3c <+108>: movl   %r8d, %r9d
 0x100000f3f <+111>: addl   $0x1, %r9d
 0x100000f43 <+115>: movl   %r9d, 局部变量a
 
 0x100000f47 <+119>: addl   %r8d, %edx
 0x100000f4a <+122>: movl   %edx, 局部变量c
 */
