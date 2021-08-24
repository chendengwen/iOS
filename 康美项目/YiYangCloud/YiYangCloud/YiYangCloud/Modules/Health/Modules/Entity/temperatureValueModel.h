//
//  temperatureValueModel.h
//  FuncGroup
//
//  Created by zhong on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface temperatureValueModel : NSObject

//温度值
@property (nonatomic,assign) CGFloat value;
//室温 | 体温
@property (nonatomic,assign) NSString *isTiwen;
//错误信息
@property (nonatomic,copy) NSString *errorStr;
//当前测量 | 历史记录
@property (nonatomic,assign) NSInteger hit;
//量测日期
@property (nonatomic,copy) NSString *data;

//字典转模型
+ (NSDictionary *)dicWithmodel:(temperatureValueModel *)model;
//模型装字典
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
