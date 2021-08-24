//
//  HealthRecordInteractor.m
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthRecordInteractor.h"
#import "bluetoothDeviceDataManager.h"
#import "HealthRecordModel.h"
#import "DBHealthRecordController.h"

@implementation HealthRecordInteractor

+(NSArray *)getHealthRecord:(HealthRecordType)type atIndex:(NSInteger)index{
    bluetoothDeviceDataManager *manager = [bluetoothDeviceDataManager sharedInstance];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    switch (type) {
        case HealthRecordXueYa:
            // 血压比较特殊，有高压、低压两个值
//            for (NSDictionary *dic in manager.BPmArray) {
//                HealthRecordModel *model = [[HealthRecordModel alloc] initWithDict:dic mapping:@{@"data":@"date",@"HBP":@"value",@"LBP":@"value2"}];
//                [dataArr addObject:model];
//            }
            break;
        case HealthRecordXueTang:
            for (NSDictionary *dic in manager.BSmArray) {
                HealthRecordModel *model = [[HealthRecordModel alloc] initWithDict:dic];
                [dataArr addObject:model];
            }
            break;
        case HealthRecordTiWen:
            for (NSDictionary *dic in manager.TmArray) {
                HealthRecordModel *model = [[HealthRecordModel alloc] initWithDict:dic];
                [dataArr addObject:model];
            }
            break;
        default:
            break;
    }
    
    return dataArr;
}

@end
