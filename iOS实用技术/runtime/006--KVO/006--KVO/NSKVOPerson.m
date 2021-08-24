//
//  NSKVOPerson.m
//  006--KVO
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import "NSKVOPerson.h"

@implementation NSKVOPerson
-(void)setAge:(int)age
{
    [self willChangeValueForKey:@"age"];
    [super setAge:age];
    [self didChangeValueForKey:@"age"];
    //.....做了很多事情
  
}
@end
