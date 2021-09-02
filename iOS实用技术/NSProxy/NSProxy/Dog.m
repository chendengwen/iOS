//
//  CLPersion.m
//  Test
//
//  Created by gary on 2021/6/11.
//

#import "Dog.h"

@implementation Dog

-(NSString *)barking:(NSInteger)months{
    return months > 3 ? @"wang wang!" : @"eng eng!";
}

@end
