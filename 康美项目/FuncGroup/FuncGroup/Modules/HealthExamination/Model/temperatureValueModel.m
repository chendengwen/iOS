//
//  temperatureValueModel.m
//  FuncGroup
//
//  Created by zhong on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "temperatureValueModel.h"

@implementation temperatureValueModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = 3;
    }
    return self;
}

+ (NSDictionary *)dicWithmodel:(temperatureValueModel *)model{

    NSDictionary *dic = @{
                          @"value":[NSString stringWithFormat:@"%.1f",model.value],
//                          @"isTiwen":model.isTiwen,
//                          @"hit":[NSString stringWithFormat:@"%zd",model.hit],
                          @"data":model.data,
//                          @"errorStr":model.errorStr
                          };
    return dic.copy;
}

//模型转字典
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    temperatureValueModel *model = [[temperatureValueModel alloc]init];
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

-(NSUInteger)T_hit{
    return self.hit;
}

-(NSString *)T_isTiwen{
    return self.isTiwen;
}

@end
