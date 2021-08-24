//
//  HealthRecordModel.h
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "HealthBaseModel.h"

@interface HealthRecordModel : HealthBaseModel

@property (nonatomic,copy) NSString *data;

//@property (nonatomic,assign) NSUInteger type;

@property (nonatomic,copy) NSString *errorStr;

@property (nonatomic,assign) float value;

@property (nonatomic,assign) NSUInteger LBP;

@property (nonatomic,assign) NSUInteger HBP;


@end
