//
//  BSValueModel.m
//  FuncGroup
//
//  Created by zhong on 2017/2/16.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BSValueModel.h"

@implementation BSValueModel

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.type = 2;
//    }
//    return self;
//}

+ (NSDictionary *)dicWithmodel:(BSValueModel *)model{
    NSDictionary *dic = @{@"value":[NSString stringWithFormat:@"%.2f",model.value],
                          @"data":model.data,
//                          @"errorStr":model.errorStr
                          };
    return dic.copy;
}

//模型转字典
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    BSValueModel *model = [[BSValueModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

#pragma mark === HealthModelProtocol
-(float)floatValue{
    return self.value;
}

-(NSString *)date{
    return self.data;
}

-(NSString *)errorString{
    return self.errorStr;
}

@end
