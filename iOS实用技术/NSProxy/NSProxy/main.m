//
//  main.m
//  Test
//
//  Created by gary on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Dog.h"

typedef void(^CLBlock)(void) ;

void func_test(CLBlock block) {
    //  block  __NSStackBlock__
    // _block_ __NSMallocBlock__
    CLBlock _block_ = block;
    _block_();
}

//int main(int argc, char * argv[]) {
//    NSString * appDelegateClassName;
//    @autoreleasepool {
//
//        TestBlock block1 = ^{
//            printf("------");
//        };
//        TestBlock test_block2 = block1;
//        NSLog(@"block = %@",block1); // __NSGlobalBlock__   地址段以0x1开头
//
//        int a = 10;
//        TestBlock block2 = ^{
//            printf("a------%d\n",a);
//        };
//        NSLog(@"block = %@",block2); // __NSMallocBlock__   地址段以0x6开头
//
//        // 没有被强引用的block才在栈区，作用域结束后就由系统释放
//        // 场景一：__weak修饰为弱引用
//        __block int b;
//        __weak TestBlock block3 = ^{  //不加__weak是__NSMallocBlock__，加__weak是__NSStackBlock__
//            printf("a------%d\n",a);
//            b=1;
//        };
//        NSLog(@"block = %@",block3); // __NSStackBlock__   地址段以0x7开头
//        block3();
//
//        NSLog(@"block = %@",^{
//          printf("a------%d\n",a);
//        }); // __NSStackBlock__   地址段以0x7开头
//
//        func_test(^{
//            NSLog(@"hello bloc %d",a);
//        });
//
//
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        NSLog(@"count ==== %d",CFGetRetainCount((__bridge CFTypeRef)array));
//    //    __block NSMutableArray *array = nil;
//        void(^Block)(void) = ^{
//    //        array = [NSMutableArray array];
//            [array addObject:@""];
//        };
//        Block();
//        NSLog(@"count ==== %d",CFGetRetainCount((__bridge CFTypeRef)array));
//
//
//
//        // Setup code that might create autoreleased objects goes here.
////        appDelegateClassName = NSStringFromClass([AppDelegate class]);
//    }
//    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
//}

//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        CLBlock myblock;
//        {
//            CLPerson *person = [[CLPerson alloc] init];
//            __block CLPerson *blockPerson = person;
//            myblock = ^ {
//                blockPerson.age = 10;
//                NSLog(@"age === %d", blockPerson.age);
//            };
//            NSLog(@"block == %@", myblock);
//        }
//        NSLog(@"block == %@", myblock);
//        myblock();
//
//    }
//}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
