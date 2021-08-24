//
//  Person.m
//  005--动态的添加方法
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//  KVO ??  内部就是使用runtime 实现的!!

#import "Person.h"
#import <objc/message.h>

@implementation Person

//当调用了一个没有实现的类方法
//+(BOOL)resolveClassMethod:(SEL)sel

//默认参数
void eat(id objc,SEL _cmd,id obj){
    NSLog(@"哥么吃了!!%@ ",obj);
}

//调用了一个没有实现的对象方法
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    //添加一个方法eat
    if (sel == @selector(eat:)) {
        //IMP 方法实现 就是一个函数指针!!
        //types:返回值类型
        class_addMethod([Person class], @selector(eat:), (IMP)eat, "v");
        
    }
    
    
    return  [super resolveClassMethod:sel];
}

@end
