//
//  Person.m
//  007--自定义KVO
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import "Person.h"

@implementation Person
-(void)setAge:(int)age
{
    //自定的处理!!
    age += 10;
    _age = age;
}
@end
