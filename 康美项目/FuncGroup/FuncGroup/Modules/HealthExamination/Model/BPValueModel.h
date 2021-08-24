//
//  BPValueModel.h
//  FuncGroup
//
//  Created by zhong on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthBaseModel.h"

@interface BPValueModel : HealthBaseModel
//舒张压
@property (nonatomic,assign) NSUInteger LBP;
//收缩压
@property (nonatomic,assign) NSUInteger HBP;
//心率
@property (nonatomic,assign) NSUInteger heartRate;
//心率状态
@property (nonatomic,copy) NSString *hearRateState;
//错误信息
@property (nonatomic,copy) NSString *errorStr;
//量测日期
@property (nonatomic,copy) NSString *data;


//字典转模型
+ (NSDictionary *)dicWithmodel:(BPValueModel *)model;
//模型装字典
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
