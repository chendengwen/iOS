//
//  HealthRecordModel.m
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthRecordModel.h"

@implementation HealthRecordModel

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

-(float)floatValue{
    return self.value;
}

+ (NSString *)getAllDBRecordByUID:(BOOL)whether{
    NSString *limitSql = whether ? @" where uid = ? " : @"";
    
    return [NSString stringWithFormat:@"select data,type,errorStr,0 as value,LBP ,HBP from [BPValueModel]"
            " %@ "
            " union "
            " select data,type,errorStr, value as value, 0 as value2,0 as value3 from [BSValueModel] "
            " %@ "
            " union "
            " select data,type,errorStr, value as value, 0 as value2,0 as value3 from [temperatureValueModel] "
            " %@ "
            " ORDER BY [data] asc",limitSql,limitSql,limitSql];
}

+ (NSString *)getAllDBRecordByUID:(BOOL)whether offset:(BOOL)offset{
    return [[[self class] getAllDBRecordByUID:whether] stringByAppendingString:offset ? @" limit 10 offset ?": @""];
}

/*!
 @brief     做联表查询 查询血糖\血压\体温三个表
 */
+ (NSString *)getDBRecordAtPageByUID:(BOOL)whether{

    return [[[self class] getAllDBRecordByUID:whether] stringByAppendingString:whether ? @" limit 10 offset ?":@""];
}



@end
