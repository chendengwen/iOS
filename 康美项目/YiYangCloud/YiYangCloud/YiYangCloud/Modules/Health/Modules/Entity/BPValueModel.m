//
//  BPValueModel.m
//  FuncGroup
//
//  Created by zhong on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BPValueModel.h"

@implementation BPValueModel

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.type = 1;
//    }
//    return self;
//}

+ (NSDictionary *)dicWithmodel:(BPValueModel *)model{
    NSDictionary *dic = @{@"LBP":[NSString stringWithFormat:@"%zd",model.LBP],
                          @"HBP":[NSString stringWithFormat:@"%zd",model.HBP],
//                          @"heartRate":[NSString stringWithFormat:@"%zd",model.heartRate],
//                          @"hearRateState":model.hearRateState,
                          @"data":model.data,
//                          @"errorStr":model.errorStr
                          };
    return dic.copy;
}

//模型转字典
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    BPValueModel *model = [[BPValueModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

#pragma mark === HealthModelProtocol
-(NSUInteger)intValue_1{
    return self.LBP;
}

-(NSUInteger)intValue_2{
    return self.HBP;
}

-(NSString *)date{
    return self.data;
}

-(NSString *)errorString{
    return self.errorStr;
}


@end
