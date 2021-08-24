//
//  NSEnumerator+Additions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "NSEnumerator+Additions.h"

@implementation NSEnumerator (Additions)

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, BOOL *stop))block
{
    if (!block) return;
    id anObject = nil;
    BOOL stop = NO;
    while (!stop && (anObject = [self nextObject]))
        block(anObject, &stop);
}

@end
