//
//  PhotoManager.m
//  Test1
//
//  Created by zheng ping on 15/12/24.
//  Copyright © 2015年 zheng ping. All rights reserved.
//

#import "PhotoManager.h"

@implementation PhotoManager

static PhotoManager *instance;

+(id) getInstance{
    @synchronized(self) {
        if ( !instance ) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(BOOL) isHengping{
    if ( ![self loadInfoWithKey:@"hengping"] ) {
//        NSLog(@"不存在 ");
        return YES;
    }else{
//        NSLog(@"存在 ");
        return NO;
    }
}

-(void) setHengping{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"hengping"];
}

-(void) setShuping{
    [self saveValue:@"hengping" WithKey:@"hengping"];}

-(void) saveValue:(NSObject *) value WithKey:(NSString *) key  {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:value forKey:key];
    [def synchronize];
}

-(NSString *) loadInfoWithKey:(NSString *) key {
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:key];
}

@end
