//
//  TestProtocol.h
//  HUDDemo
//
//  Created by gary on 2021/10/14.
//  Copyright © 2021 成都卓牛科技. All rights reserved.
//
#import <UIKit/UIApplication.h>

@protocol TestProtocol <UIApplicationDelegate>

-(void)test;

@property(copy) NSString * title_protocol;

@end
