//
//  HealthRecordPublic.m
//  FuncGroup
//
//  Created by gary on 2017/2/24.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthRecordPublic.h"

NSString * GetDBControllerType(HealthRecordType type){
    switch (type) {
            case HealthRecordAll:
            return @"DBHealthRecordController";
        case HealthRecordXueYa:
            return @"";
        case HealthRecordXueTang:
            return @"";
        case HealthRecordTiWen:
            return @"";
        default:
            break;
    }
    return nil;
}

NSString * getUnit(HealthRecordType type){
    switch (type) {
        case HealthRecordXueTang:
            return @"血糖值(mmol/L)";
            break;
        case HealthRecordXueYa:
            return @"舒张压(mmHg)";
        case HealthRecordTiWen:
            return @"温度值(ºC)";
        default:
            return @"历史量测";
            break;
    }
}

@implementation HealthRecordPublic 



@end

