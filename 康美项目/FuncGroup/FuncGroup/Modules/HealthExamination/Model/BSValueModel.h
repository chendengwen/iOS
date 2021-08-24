//
//  BSValueModel.h
//  FuncGroup
//
//  Created by zhong on 2017/2/16.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthBaseModel.h"

@interface BSValueModel : HealthBaseModel

//血糖值
@property (nonatomic,assign) CGFloat value;
//错误信息
@property (nonatomic,copy) NSString *errorStr;
//量测日期
@property (nonatomic,copy) NSString *data;

//字典转模型
+ (NSDictionary *)dicWithmodel:(BSValueModel *)model;
//模型装字典
+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end
