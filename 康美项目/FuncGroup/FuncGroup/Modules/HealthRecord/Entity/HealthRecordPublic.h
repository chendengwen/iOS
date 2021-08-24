//
//  HealthRecordPublic.h
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

typedef enum: int{
    HealthRecordAll,        // 全部
    HealthRecordXueYa,      // 血压
    HealthRecordXueTang,    // 血糖
    HealthRecordTiWen       // 体温
}HealthRecordType;

NSString * GetDBControllerType(HealthRecordType type);

NSString * getUnit(HealthRecordType type);

@interface HealthRecordPublic : NSObject


@end

