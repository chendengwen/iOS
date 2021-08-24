//
//  HealthModelProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HealthModelProtocol <NSObject>

@optional
-(NSString *)date;

-(NSString *)errorString;

-(NSUInteger)intValue_1;

-(NSUInteger)intValue_2;

-(float)floatValue;

-(NSUInteger)type;

// 体温测量相关
-(NSUInteger)T_hit;
-(NSString *)T_isTiwen;



@end
